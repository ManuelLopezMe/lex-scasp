:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

% Section 9(1): birth must be in a foreign country during the first five years after commencement.
section9_birth_window_requirement(Person) :-
    fact(Person, section9_months_after_commencement_at_birth, Months),
    Months >= 0,
    Months =< 60.

% Section 9(1): application must be made within twelve months after birth.
section9_application_window_requirement(Person) :-
    fact(Person, section9_months_after_birth_at_application, Months),
    Months >= 0,
    Months =< 12.

% Section 9(1)(a), (2): the specified pre-commencement paternal status and marriage facts are externally established.
section9_father_requirements_met(Person) :-
    fact(Person, section9_father_subsection_2_requirements_met, true).

% Section 9(1)(b): the hypothetical legacy registration and right-of-abode result is an external counterfactual input.
section9_hypothetical_legacy_right_of_abode_met(Person) :-
    fact(Person, section9_hypothetical_1948_act_registration_would_give_right_of_abode, true).

% Section 9(1): registration entitlement requires the foreign birth, timely application, paternal, and counterfactual tests.
section9_entitled_to_registration(Person) :-
    fact(Person, section9_born_in_foreign_country, true),
    section9_birth_window_requirement(Person),
    section9_application_window_requirement(Person),
    fact(Person, registration_application, true),
    section9_father_requirements_met(Person),
    section9_hypothetical_legacy_right_of_abode_met(Person).
