:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

% Section 6(1): the general naturalisation route requires an adult applicant of full capacity and an application.
section6_general_application(Person) :-
    fact(Person, naturalisation_application, true),
    fact(Person, full_age, true),
    fact(Person, full_capacity, true).

% Section 6(2): the spouse route requires an adult applicant of full capacity married to a British citizen.
section6_spouse_application(Person) :-
    fact(Person, naturalisation_application, true),
    fact(Person, full_age, true),
    fact(Person, full_capacity, true),
    fact(Person, married_to_british_citizen_on_application_date, true).

% Section 6(1): Schedule 1's general-route requirements are represented as an explicit external determination.
section6_meets_schedule1(Person, general) :-
    fact(Person, section6_schedule1_general_requirements_met, true).

% Section 6(2): Schedule 1's spouse-route requirements are represented as an explicit external determination.
section6_meets_schedule1(Person, spouse) :-
    fact(Person, section6_schedule1_spouse_requirements_met, true).

% Section 6(1): the Secretary of State may grant naturalisation on the general route when the Schedule 1 test is met.
section6_may_grant_naturalisation(Person) :-
    section6_general_application(Person),
    section6_meets_schedule1(Person, general),
    fact(Person, secretary_of_state_approves_naturalisation, true).

% Section 6(2): the Secretary of State may grant naturalisation on the spouse route when the Schedule 1 test is met.
section6_may_grant_naturalisation(Person) :-
    section6_spouse_application(Person),
    section6_meets_schedule1(Person, spouse),
    fact(Person, secretary_of_state_approves_naturalisation, true).
