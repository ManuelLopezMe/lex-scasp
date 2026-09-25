:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

% Section 5: a BDT citizen treated as a UK national for Community Treaty purposes is entitled on application.
section5_entitled_to_registration(Person) :-
    fact(Person, section5_is_bdt_citizen, true),
    fact(Person, section5_treated_as_uk_national_for_community_treaties, true),
    fact(Person, registration_application, true).
