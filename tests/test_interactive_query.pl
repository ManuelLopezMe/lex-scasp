:- use_module(library(plunit)).
:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').
:- use_module('../scripts/interactive_query.pl').

:- begin_tests(interactive_query_propagation).

with_person(Person, Goal) :-
    setup_call_cleanup(
        retractall(bna_facts:fact(Person, _, _)),
        call(Goal),
        retractall(bna_facts:fact(Person, _, _))).

test(uk_birth_infers_overseas_birth_false) :-
    with_person(andrew,
        ( interactive_query:propagate_fact(andrew, born_in_uk, true),
          bna_facts:fact(andrew, born_outside_uk, false)
        )).

test(not_born_in_uk_infers_overseas_birth) :-
    with_person(andrew,
        ( interactive_query:propagate_fact(andrew, born_in_uk, false),
          bna_facts:fact(andrew, born_outside_uk, true)
        )).

test(overseas_birth_infers_uk_birth_false) :-
    with_person(andrew,
        ( interactive_query:propagate_fact(andrew, born_outside_uk, true),
          bna_facts:fact(andrew, born_in_uk, false)
        )).

test(not_born_outside_uk_infers_uk_birth) :-
    with_person(andrew,
        ( interactive_query:propagate_fact(andrew, born_outside_uk, false),
          bna_facts:fact(andrew, born_in_uk, true)
        )).

test(non_citizen_parent_cannot_be_citizen_otherwise_than_descent) :-
    with_person(andrew,
        ( interactive_query:propagate_fact(andrew, parent_is_citizen, false),
          bna_facts:fact(
              andrew, parent_is_citizen_otherwise_than_descent, false)
        )).

test(citizen_otherwise_than_descent_implies_citizen) :-
    with_person(andrew,
        ( interactive_query:propagate_fact(
              andrew, parent_is_citizen_otherwise_than_descent, true),
          bna_facts:fact(andrew, parent_is_citizen, true)
        )).

test(false_commencement_skips_rules_requiring_commencement) :-
    with_person(andrew,
        ( interactive_query:collect_fact_branches(
                user:is_british_citizen(andrew), [], Branches),
          assertz(bna_facts:fact(andrew, after_commencement, false)),
          include(interactive_query:branch_is_possible, Branches, Active),
          \+ ( member(Branch, Active),
               member(andrew-after_commencement-true, Branch)
             )
        )).

test(uk_birth_skips_overseas_birth_rules) :-
    with_person(andrew,
        ( interactive_query:collect_fact_branches(
                user:is_british_citizen(andrew), [], Branches),
          assertz(bna_facts:fact(andrew, born_in_uk, true)),
          interactive_query:propagate_fact(andrew, born_in_uk, true),
          include(interactive_query:branch_is_possible, Branches, Active),
          \+ ( member(Branch, Active),
               member(andrew-born_outside_uk-true, Branch)
             )
        )).

test(false_parent_citizenship_skips_stronger_parent_citizenship_fact) :-
    with_person(andrew,
        ( interactive_query:collect_fact_branches(
                user:is_british_citizen(andrew), [], Branches),
          assertz(bna_facts:fact(andrew, parent_is_citizen, false)),
          interactive_query:propagate_fact(andrew, parent_is_citizen, false),
          include(interactive_query:branch_is_possible, Branches, Active),
          \+ ( member(Branch, Active),
               member(
                   andrew-parent_is_citizen_otherwise_than_descent-true,
                   Branch)
             )
        )).

test(uk_birth_to_citizen_parent_proves_convenience_query) :-
    with_person(jamie,
        (         assertz(bna_facts:fact(jamie, born_in_uk, true)),
        assertz(bna_facts:fact(jamie, after_commencement, true)),
        assertz(bna_facts:fact(jamie, parent_is_citizen, true)),
        once(scasp(user:is_british_citizen(jamie), []))
        )).

test(unknown_atom_is_not_sent_to_scasp) :-
    \+ interactive_query:resolve_query(no, _).

:- end_tests(interactive_query_propagation).
