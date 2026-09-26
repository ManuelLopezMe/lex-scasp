:- module(interactive_query, [main/0]).

:- use_module(library(apply)).
:- use_module(library(filesex)).
:- use_module(library(lists)).
:- use_module(library(readutil)).
:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

:- dynamic user:is_british_citizen/1.

is_rule_file(File) :-
    file_name_extension(_, pl, File),
    sub_atom(File, 0, 8, _, 'section_').

load_rule_files :-
    prolog_load_context(directory, ScriptDir),
    directory_file_path(ScriptDir, '..', RepositoryDir),
    directory_file_path(RepositoryDir, 'rules', RulesDir),
    directory_files(RulesDir, Entries),
    include(is_rule_file, Entries, RuleNames),
    sort(RuleNames, SortedRuleNames),
    maplist(directory_file_path(RulesDir), SortedRuleNames, RuleFiles),
    load_files(user:RuleFiles, [if(not_loaded)]).

:- load_rule_files.

% Sections 1(1)-(6): expose the modeled birth and adoption citizenship routes.
:- assertz(user:(is_british_citizen(Person) :-
                    section1_british_citizen(Person))).

% Section 2(1): expose the modeled citizenship-by-descent routes.
:- assertz(user:(is_british_citizen(Person) :-
                    section2_british_citizen(Person))).

start :-
    main.

:- initialization(start, main).

main :-
    format('British Nationality Act research model (not legal advice).~n'),
    format('Enter a Prolog query (for example, ?- is_british_citizen(peter).).~n'),
    format('Type quit to exit.~n'),
    query_loop.

query_loop :-
    format('query> '),
    flush_output,
    read_line_to_string(user_input, Line),
    (   Line == end_of_file
    ->  true
    ;   normalize_space(string(Input), Line),
        handle_input(Input, Continue),
        ( Continue == true -> query_loop ; true )
    ).

handle_input("", true) :-
    !.
handle_input("quit", false) :-
    !.
handle_input("exit", false) :-
    !.
handle_input(Input, true) :-
    strip_query_prompt(Input, QueryText),
    catch(read_term_from_atom(QueryText, Query, [variable_names(Variables)]),
          Error,
          report_parse_error(Error)),
    (   nonvar(Query)
    ->  run_query(Query, Variables)
    ;   true
    ).

strip_query_prompt(Input, QueryText) :-
    (   sub_string(Input, 0, 2, _, "?-")
    ->  sub_string(Input, 2, _, 0, Remainder),
        normalize_space(string(QueryText), Remainder)
    ;   QueryText = Input
    ).

report_parse_error(Error) :-
    print_message(error, Error).

run_query(Query, Variables) :-
    (   resolve_query(Query, SolverQuery)
    ->  (   prompt_for_missing_facts(SolverQuery)
        ->  (   once(scasp(SolverQuery, [tree(Tree)]))
            ->  format('Proved: '),
                write_term(Query, [quoted(true)]),
                nl,
                print_bindings(Variables),
                format('s(CASP) justification tree:~n'),
                scasp_stack:print_justification_tree(Tree, [])
            ;   format('Not proved: '),
                write_term(Query, [quoted(true)]),
                nl
            )
        ;   format('Input ended; query cancelled.~n')
        )
    ;   functor(Query, Name, Arity),
        format('Unknown query predicate: ~w/~d.~n', [Name, Arity])
    ).

resolve_query(Query, interactive_query:Query) :-
    functor(Query, Name, Arity),
    current_predicate(interactive_query:Name/Arity),
    !.
resolve_query(Query, user:Query) :-
    functor(Query, Name, Arity),
    current_predicate(user:Name/Arity),
    !.

print_bindings([]) :-
    !.
print_bindings(Variables) :-
    maplist(print_binding, Variables).

print_binding(Name=Value) :-
    format('  ~w = ', [Name]),
    write_term(Value, [quoted(true)]),
    nl.

collect_fact_branches(Goal, _, [[Person-Property-Value]]) :-
    nonvar(Goal),
    Goal = fact(Person, Property, Value),
    !.
collect_fact_branches(_Module:Goal, Seen, Branches) :-
    !,
    collect_fact_branches(Goal, Seen, Branches).
collect_fact_branches((Left, Right), Seen, Branches) :-
    !,
    collect_fact_branches(Left, Seen, LeftBranches),
    collect_fact_branches(Right, Seen, RightBranches),
    combine_branches(LeftBranches, RightBranches, Branches).
collect_fact_branches((Left; Right), Seen, Branches) :-
    !,
    collect_fact_branches(Left, Seen, LeftBranches),
    collect_fact_branches(Right, Seen, RightBranches),
    append(LeftBranches, RightBranches, Branches).
collect_fact_branches(\+ _, _, [[]]) :-
    !.
collect_fact_branches(not(_), _, [[]]) :-
    !.
collect_fact_branches(true, _, [[]]) :-
    !.
collect_fact_branches(Goal, _, [[]]) :-
    callable(Goal),
    predicate_property(interactive_query:Goal, built_in),
    !.
collect_fact_branches(Goal, Seen, Branches) :-
    callable(Goal),
    functor(Goal, Name, Arity),
    (   memberchk(Name/Arity, Seen)
    ->  Branches = []
    ;   functor(Head, Name, Arity),
        findall(Found,
                ( rule_clause(Head, Body),
                  Head = Goal,
                  collect_fact_branches(Body, [Name/Arity|Seen], RuleBranches),
                  member(Found, RuleBranches)
                ),
                Branches)
    ).

rule_clause(Head, Body) :-
    clause(interactive_query:Head, Body).
rule_clause(Head, Body) :-
    clause(user:Head, Body).

combine_branches(LeftBranches, RightBranches, Branches) :-
    findall(Combined,
            ( member(Left, LeftBranches),
              member(Right, RightBranches),
              append(Left, Right, Combined)
            ),
            Branches).

prompt_for_missing_facts(Query) :-
    collect_fact_branches(Query, [], Branches),
    prompt_active_branches(Branches).

prompt_active_branches(Branches) :-
    include(branch_is_possible, Branches, ActiveBranches),
    active_missing_fact(ActiveBranches, Person, Property),
    !,
    ask_for_value(Person, Property, Answer),
    assertz(bna_facts:fact(Person, Property, Answer)),
    propagate_fact(Person, Property, Answer),
    prompt_active_branches(Branches).
prompt_active_branches(_).

branch_is_possible(Branch) :-
    maplist(fact_is_consistent, Branch).

fact_is_consistent(Person-Property-RequiredValue) :-
    (   bna_facts:fact(Person, Property, KnownValue)
    ->  (   nonvar(RequiredValue)
        ->  KnownValue == RequiredValue
        ;   true
        )
    ;   true
    ).

active_missing_fact(Branches, Person, Property) :-
    member(Branch, Branches),
    member(Person-Property-_, Branch),
    ground(Person-Property),
    \+ bna_facts:fact(Person, Property, _),
    !.

propagate_fact(Person, born_in_uk, true) :-
    !,
    infer_fact(Person, born_outside_uk, false).
propagate_fact(Person, born_in_uk, false) :-
    !,
    infer_fact(Person, born_outside_uk, true).
propagate_fact(Person, born_outside_uk, true) :-
    !,
    infer_fact(Person, born_in_uk, false).
propagate_fact(Person, born_outside_uk, false) :-
    !,
    infer_fact(Person, born_in_uk, true).
propagate_fact(Person, parent_is_citizen, false) :-
    !,
    infer_fact(Person, parent_is_citizen_otherwise_than_descent, false).
propagate_fact(Person, parent_is_citizen_otherwise_than_descent, true) :-
    !,
    infer_fact(Person, parent_is_citizen, true).
propagate_fact(_, _, _).

infer_fact(Person, Property, Value) :-
    (   bna_facts:fact(Person, Property, Existing)
    ->  (   Existing == Value
        ->  true
        ;   format('Warning: not inferring ~w = ~w because ~w = ~w is already recorded.~n',
                   [Property, Value, Property, Existing])
        )
    ;   assertz(bna_facts:fact(Person, Property, Value))
    ).

ask_for_value(Person, Property, Answer) :-
    numeric_property(Property),
    !,
    format('What is ~w ~w? (enter a number): ', [Person, Property]),
    flush_output,
    read_line_to_string(user_input, Response),
    (   Response == end_of_file
    ->  fail
    ;   number_string(Answer, Response)
    ->  true
    ;   format('Please enter a number.~n'),
        ask_for_value(Person, Property, Answer)
    ).
ask_for_value(Person, Property, Answer) :-
    format('Is ~w ~w? (yes/no): ', [Person, Property]),
    flush_output,
    read_line_to_string(user_input, Response),
    (   Response == end_of_file
    ->  fail
    ;   yes_no_value(Response, Answer)
    ->  true
    ;   format('Please answer yes or no.~n'),
        ask_for_value(Person, Property, Answer)
    ).

numeric_property(Property) :-
    (   Property == age_at_application
    ;   sub_atom(Property, _, _, _, 'days')
    ;   sub_atom(Property, _, _, _, 'months')
    ;   sub_atom(Property, _, _, _, 'years')
    ).

yes_no_value(Response, Value) :-
    string_lower(Response, LowerResponse),
    (   LowerResponse == "yes"
    ->  Value = true
    ;   LowerResponse == "no",
        Value = false
    ).
