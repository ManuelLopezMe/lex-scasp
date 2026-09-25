:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

% Section 19(3): the special-circumstances eight-year extension has priority over the ordinary five-year period.
section19_priority(s19_eight_year_extension, 20).

% Section 19(1)-(2): the ordinary five-year application period has lower priority than subsection (3) relief.
section19_priority(s19_five_year_window, 10).

% Section 19(1)-(3): numeric priority records the power to extend either application period.
section19_higher_priority(HigherRule, LowerRule) :-
    section19_priority(HigherRule, HigherRank),
    section19_priority(LowerRule, LowerRank),
    HigherRank > LowerRank.

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
    fact(Person, section19_secretary_approves_eight_year_extension, true),
    section19_higher_priority(s19_eight_year_extension, s19_five_year_window).

% Section 19(2)-(3): a minor at commencement may use eight years from full age if special circumstances are approved.
section19_entitled_to_registration(Person) :-
    fact(Person, registration_application, true),
    fact(Person, section19_minor_at_commencement, true),
    fact(Person, section19_immigration_act_schedule_1_paragraph_2_counterfactual_entitlement, true),
    fact(Person, section19_application_within_eight_years_after_full_age, true),
    fact(Person, section19_secretary_approves_eight_year_extension, true),
    section19_higher_priority(s19_eight_year_extension, s19_five_year_window).
