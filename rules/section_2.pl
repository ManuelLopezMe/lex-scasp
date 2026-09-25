:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

% Section 2(1)(a): an overseas-born person qualifies through a British parent
% who is a citizen otherwise than by descent.
section2_british_citizen(Person) :-
    fact(Person, born_outside_uk, true),
    fact(Person, after_commencement, true),
    fact(Person, parent_is_citizen_otherwise_than_descent, true).

% Section 2(1)(b), (2): a qualifying Crown or designated-service parent recruited
% in the UK passes citizenship to an overseas-born child.
section2_british_citizen(Person) :-
    fact(Person, born_outside_uk, true),
    fact(Person, after_commencement, true),
    fact(Person, parent_has_qualifying_service, true).

% Section 2(1)(c): a parent serving a Community institution and recruited in a
% member country qualifies for an overseas-born child.
section2_british_citizen(Person) :-
    fact(Person, born_outside_uk, true),
    fact(Person, after_commencement, true),
    fact(Person, parent_has_community_service, true).
