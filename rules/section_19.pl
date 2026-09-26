:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

% Section 19(1): a person with the specified counterfactual Immigration Act entitlement may register within five years after commencement.
section19_entitled_to_registration(Person) :-
    fact(Person, registration_application, true),
    fact(Person, section19_minor_at_commencement, false),
    fact(Person, section19_immigration_act_schedule_1_paragraph_2_counterfactual_entitlement, true),
    fact(Person, section19_application_within_five_years_after_commencement, true).

% Section 19(2): for a minor at commencement, the ordinary five-year period runs from attaining full age.
section19_entitled_to_registration(Person) :-
    fact(Person, registration_application, true),
    fact(Person, section19_minor_at_commencement, true),
    fact(Person, section19_immigration_act_schedule_1_paragraph_2_counterfactual_entitlement, true),
    fact(Person, section19_application_within_five_years_after_full_age, true).

% Section 19(1), (3): a non-minor at commencement may use the eight-year period if special circumstances are approved.
section19_entitled_to_registration(Person) :-
    fact(Person, registration_application, true),
    fact(Person, section19_minor_at_commencement, false),
    fact(Person, section19_immigration_act_schedule_1_paragraph_2_counterfactual_entitlement, true),
    fact(Person, section19_application_within_eight_years_after_commencement, true),
    fact(Person, section19_secretary_approves_eight_year_extension, true).

% Section 19(2)-(3): a minor at commencement may use eight years from full age if special circumstances are approved.
section19_entitled_to_registration(Person) :-
    fact(Person, registration_application, true),
    fact(Person, section19_minor_at_commencement, true),
    fact(Person, section19_immigration_act_schedule_1_paragraph_2_counterfactual_entitlement, true),
    fact(Person, section19_application_within_eight_years_after_full_age, true),
    fact(Person, section19_secretary_approves_eight_year_extension, true).
