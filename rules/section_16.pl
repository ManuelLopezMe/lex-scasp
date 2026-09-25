:- use_module(library(scasp)).
:- use_module('../facts/rdf_facts.pl').

% Section 16(1)(a): overseas birth after commencement to a BDT citizen otherwise than by descent confers citizenship.
section16_acquires_bdt_citizenship(Person) :-
    fact(Person, born_outside_dependent_territories, true),
    fact(Person, after_commencement, true),
    fact(Person, section16_parent_bdt_citizen_otherwise_than_by_descent_at_birth, true).

% Section 16(1)(b), (2)(a): a citizen-parent's qualifying dependent-territory Crown service and local recruitment confer citizenship by descent.
section16_acquires_bdt_citizenship(Person) :-
    fact(Person, born_outside_dependent_territories, true),
    fact(Person, after_commencement, true),
    fact(Person, section16_parent_bdt_citizen_at_birth, true),
    fact(Person, section16_parent_serving_outside_dependent_territories_at_birth, true),
    fact(Person, section16_parent_service_type, dependent_territory_crown),
    fact(Person, section16_parent_recruited_in_dependent_territory, true).

% Section 16(1)(b), (2)(b), (3): service designated under subsection (3), with local recruitment, confers citizenship by descent.
section16_acquires_bdt_citizenship(Person) :-
    fact(Person, born_outside_dependent_territories, true),
    fact(Person, after_commencement, true),
    fact(Person, section16_parent_bdt_citizen_at_birth, true),
    fact(Person, section16_parent_serving_outside_dependent_territories_at_birth, true),
    fact(Person, section16_parent_service_type, designated_service),
    section16_service_description_designated(Person),
    fact(Person, section16_parent_recruited_in_dependent_territory, true).

% Section 16(3): whether a service description was designated by statutory instrument is an explicit external input.
section16_service_description_designated(Person) :-
    fact(Person, section16_service_description_designated_by_order, true).
