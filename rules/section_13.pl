:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

% Section 13(1): the mandatory resumption route requires a prior loss by renunciation, full capacity, and application.
section13_basic_resumption_requirements(Person) :-
    fact(Person, section13_ceased_british_citizen_by_renunciation, true),
    fact(Person, full_capacity, true),
    fact(Person, registration_application, true).

% Section 13(2): the entitlement route is unavailable after a prior subsection (1) registration.
section13_once_only_requirement(Person) :-
    fact(Person, section13_prior_subsection_1_registration, false).

% Section 13(1)(b), (2): the entitlement requires necessary renunciation and is available only once.
section13_entitled_to_registration(Person) :-
    section13_basic_resumption_requirements(Person),
    fact(Person, section13_renunciation_necessary_for_other_nationality, true),
    section13_once_only_requirement(Person).

% Section 13(3): the Secretary of State may register a full-capacity former citizen regardless of why renunciation occurred.
section13_may_register(Person) :-
    fact(Person, section13_ceased_british_citizen_by_renunciation, true),
    fact(Person, full_capacity, true),
    fact(Person, registration_application, true),
    fact(Person, secretary_of_state_approves_registration, true).
