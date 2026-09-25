:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

% Section 18(1): general naturalisation requires application, full age and capacity, specified relevant territory, Schedule 1 satisfaction, and ministerial approval.
section18_may_grant_naturalisation(Person) :-
    fact(Person, naturalisation_application, true),
    fact(Person, full_age, true),
    fact(Person, full_capacity, true),
    fact(Person, section18_relevant_dependent_territory_specified, true),
    fact(Person, section18_schedule1_general_requirements_satisfied, true),
    fact(Person, secretary_of_state_approves_naturalisation, true).

% Section 18(2): spouse naturalisation requires marriage to a BDT citizen on application and separate Schedule 1 satisfaction.
section18_may_grant_naturalisation(Person) :-
    fact(Person, naturalisation_application, true),
    fact(Person, full_age, true),
    fact(Person, full_capacity, true),
    fact(Person, married_to_bdt_citizen_on_application_date, true),
    fact(Person, section18_relevant_dependent_territory_specified, true),
    fact(Person, section18_schedule1_spouse_requirements_satisfied, true),
    fact(Person, secretary_of_state_approves_naturalisation, true).
