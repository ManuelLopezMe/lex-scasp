:- use_module(library(scasp)).
:- use_module('../facts/rdf_facts.pl').

% Section 26: a CUKC who becomes neither a British citizen nor a BDT citizen at commencement becomes a BOC.
section26_becomes_boc(Person) :-
    fact(Person, cukc_immediately_before_commencement, true),
    fact(Person, becomes_british_citizen_at_commencement, false),
    fact(Person, becomes_bdt_citizen_at_commencement, false).
