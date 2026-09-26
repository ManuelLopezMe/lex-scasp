:- module(interactive_query, [main/0, is_british_citizen/1]).

:- use_module(library(apply)).
:- use_module(library(filesex)).
:- use_module(library(lists)).
:- use_module(library(readutil)).
:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

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
    load_files(interactive_query:RuleFiles, [if(not_loaded)]).

:- load_rule_files.

% Sections 1(1)-(6): expose the modeled birth and adoption citizenship routes.
is_british_citizen(Person) :-
    section1_british_citizen(Person).

% Section 2(1): expose the modeled citizenship-by-descent routes.
is_british_citizen(Person) :-
    section2_british_citizen(Person).

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
    collect_fact_properties(Query, [], Properties),
    (   prompt_for_missing_facts(Properties)
    ->  (   once(scasp(Query, [tree(Tree)]))
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
    ).

print_bindings([]) :-
    !.
print_bindings(Variables) :-
    maplist(print_binding, Variables).

print_binding(Name=Value) :-
    format('  ~w = ', [Name]),
    write_term(Value, [quoted(true)]),
    nl.

collect_fact_properties(Goal, _, Properties) :-
    nonvar(Goal),
    Goal = fact(Person, Property, _),
    !,
    Properties = [Person-Property].
collect_fact_properties(Goal, Seen, Properties) :-
    callable(Goal),
    functor(Goal, Name, Arity),
    (   memberchk(Name/Arity, Seen)
    ->  Properties = []
    ;   functor(Head, Name, Arity),
        findall(Found,
                ( clause(interactive_query:Head, Body),
                  Head = Goal,
                  collect_body_properties(Body, [Name/Arity|Seen], Found)
                ),
                Nested),
        append(Nested, Properties)
    ).

collect_body_properties((Left, Right), Seen, Properties) :-
    !,
    collect_body_properties(Left, Seen, LeftProperties),
    collect_body_properties(Right, Seen, RightProperties),
    append(LeftProperties, RightProperties, Properties).
collect_body_properties(fact(Person, Property, _), _, [Person-Property]) :-
    !.
collect_body_properties(Goal, _, Properties) :-
    callable(Goal),
    predicate_property(interactive_query:Goal, built_in),
    !,
    Properties = [].
collect_body_properties(Goal, Seen, Properties) :-
    collect_fact_properties(Goal, Seen, Properties).

prompt_for_missing_facts(Properties) :-
    sort(Properties, UniqueProperties),
    maplist(prompt_for_missing_fact, UniqueProperties).

prompt_for_missing_fact(Person-Property) :-
    ground(Person-Property),
    (   bna_facts:fact(Person, Property, _)
    ->  true
    ;   ask_for_value(Person, Property, Answer),
        assertz(bna_facts:fact(Person, Property, Answer))
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
