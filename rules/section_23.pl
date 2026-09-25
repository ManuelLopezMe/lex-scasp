:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

% Section 23(1)(a): birth, naturalisation or registration as a CUKC in a dependent territory qualifies for BDT citizenship at commencement.
section23_territorial_cukc_basis(Person) :-
    fact(Person, section23_cukc_acquired_by_birth_in_dependent_territory, true).

% Section 23(1)(a): naturalisation as a CUKC in a dependent territory qualifies at commencement.
section23_territorial_cukc_basis(Person) :-
    fact(Person, section23_cukc_acquired_by_naturalisation_in_dependent_territory, true).

% Section 23(1)(a): registration as a CUKC in a dependent territory qualifies at commencement.
section23_territorial_cukc_basis(Person) :-
    fact(Person, section23_cukc_acquired_by_registration_in_dependent_territory, true).

% Section 23(1)(a): the territorial basis applies to a CUKC immediately before commencement.
section23_becomes_bdt_citizen_at_commencement(Person) :-
    fact(Person, section23_cukc_immediately_before_commencement, true),
    section23_territorial_cukc_basis(Person).

% Section 23(1)(b)(i)-(ii): a CUKC born to a qualifying CUKC parent becomes a BDT citizen at commencement.
section23_becomes_bdt_citizen_at_commencement(Person) :-
    fact(Person, section23_cukc_immediately_before_commencement, true),
    fact(Person, section23_born_to_cukc_parent_at_material_time, true),
    fact(Person, section23_parent_cukc_territorial_origin_or_qualifying_parent, true).

% Section 23(1)(c): a woman CUKC at commencement becomes a BDT citizen through a husband who qualifies under (a) or (b), including but-for-death cases.
section23_becomes_bdt_citizen_at_commencement(Person) :-
    fact(Person, section23_woman_cukc_immediately_before_commencement, true),
    fact(Person, section23_was_or_had_been_wife_of_qualifying_man, true),
    fact(Person, section23_husband_becomes_bdt_under_subsection_1_a_or_b_or_would_but_for_death, true).

% Section 23(2)(a)-(c): a minor/stateless registration outside a dependent territory follows the applicable parent link and that parent's commencement status.
section23_becomes_bdt_citizen_at_commencement(Person) :-
    fact(Person, section23_cukc_immediately_before_commencement, true),
    fact(Person, section23_cukc_registered_under_1948_act_section_7_or_1964_stateless_act, true),
    fact(Person, section23_registration_outside_dependent_territory, true),
    fact(Person, section23_applicable_parent_cukc_at_registration_or_would_but_for_death, true),
    fact(Person, section23_applicable_parent_becomes_bdt_at_commencement_or_would_but_for_death, true).

% Section 23(3)(a)-(b): the specified male-line 1948 Act registration qualifies when the relevant person's territorial qualification is met.
section23_becomes_bdt_citizen_at_commencement(Person) :-
    fact(Person, section23_cukc_immediately_before_commencement, true),
    fact(Person, section23_cukc_registered_under_1948_act_section_12_6, true),
    fact(Person, section23_registration_outside_dependent_territory, true),
    fact(Person, section23_section_12_6_historical_descent_conditions_met, true),
    fact(Person, section23_relevant_person_born_or_naturalised_in_dependent_territory_or_annexed, true).

% Section 23(4)-(5): a section 1 1964 Act resumption registration outside a territory qualifies through the applicant's prescribed connection.
section23_becomes_bdt_citizen_at_commencement(Person) :-
    fact(Person, section23_cukc_immediately_before_commencement, true),
    fact(Person, section23_cukc_registered_under_1964_act_section_1_resumption, true),
    fact(Person, section23_registration_outside_dependent_territory, true),
    section23_appropriate_qualifying_connection(Person).

% Section 23(4)-(5): a woman's resumption registration qualifies through her spouse's prescribed connection.
section23_becomes_bdt_citizen_at_commencement(Person) :-
    fact(Person, section23_cukc_immediately_before_commencement, true),
    fact(Person, section23_cukc_registered_under_1964_act_section_1_resumption, true),
    fact(Person, section23_registration_outside_dependent_territory, true),
    fact(Person, section23_woman, true),
    fact(Person, section23_spouse_has_appropriate_qualifying_connection, true).

% Section 23(5)(a): birth of the applicant, father or father's father in a dependent territory is the prescribed connection.
section23_appropriate_qualifying_connection(Person) :-
    fact(Person, section23_connection_qualification, birth_in_dependent_territory).

% Section 23(5)(b): naturalisation of the applicant, father or father's father in a dependent territory is the prescribed connection.
section23_appropriate_qualifying_connection(Person) :-
    fact(Person, section23_connection_qualification, naturalisation_in_dependent_territory).

% Section 23(5)(c): registration of the applicant, father or father's father as a CUKC in a dependent territory is the prescribed connection.
section23_appropriate_qualifying_connection(Person) :-
    fact(Person, section23_connection_qualification, cukc_registration_in_dependent_territory).

% Section 23(5)(d): British-subject status through annexation of territory now included in a dependent territory is the prescribed connection.
section23_appropriate_qualifying_connection(Person) :-
    fact(Person, section23_connection_qualification, british_subject_by_dependent_territory_annexation).
