% Interactive query interface
:- use_module(library(scasp)).
:- ensure_loaded('rules/section_1.pl').
:- use_module('facts/facts.pl').

% Simple interactive query loop
query_citizen(Person, Section) :-
    format('Querying: Is ~w a British citizen under section ~w?~n', [Person, Section]),
    % Build the predicate dynamically
    Predicate =.. [section_predicate, Person],
    (scasp(Predicate, []) ->
        format('YES: ~w is a British citizen.~n', [Person])
    ;
        format('NO: ~w is not a British citizen.~n', [Person])
    ).

% Prompt user for facts
prompt_fact(Property, Person, Value) :-
    format('Is ~w ~w? (yes/no): ', [Person, Property]),
    read_line_to_codes(user_input, Input),
    (Input = "yes" -> assert(fact(Person, Property, true))
    ; Input = "no" -> assert(fact(Person, Property, false))
    ; prompt_fact(Property, Person, Value)).