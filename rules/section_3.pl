:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

% Section 3(1): registration is discretionary for a minor applicant when the
% Secretary of State approves the application.
section3_may_register(Person) :-
    fact(Person, minor_at_application, true),
    fact(Person, registration_application, true),
    fact(Person, secretary_of_state_approves_registration, true).

% Section 3(2): an application made within twelve months is timely.
section3_application_is_timely(Person) :-
    fact(Person, application_months_after_birth, Months),
    Months =< 12.

% Section 3(4): special circumstances extend the application period to six years.
section3_application_is_timely(Person) :-
    fact(Person, application_months_after_birth, Months),
    Months =< 72,
    fact(Person, secretary_of_state_special_circumstances, true).

% Section 3(3)(a)-(b): the parent was a citizen by descent and has a qualifying grandparent.
section3_parent_ancestry_qualified(Person) :-
    fact(Person, parent_is_citizen_by_descent, true),
    fact(Person, section3_parent_ancestry_qualified, true).

% Section 3(3)(c): the parent meets the qualifying three-year UK residence test.
section3_parent_residence_before_birth(Person) :-
    fact(Person, section3_parent_in_uk_at_start, true),
    fact(Person, section3_period_ends_by_birth, true),
    fact(Person, section3_parent_absence_days, Days),
    Days =< 270.

% Section 3(2)-(3): a non-stateless overseas-born applicant qualifies through a
% parent meeting the ancestry, residence, and application requirements.
section3_entitled_under_subsection_2(Person) :-
    fact(Person, born_outside_uk, true),
    fact(Person, born_stateless, false),
    fact(Person, registration_application, true),
    section3_application_is_timely(Person),
    section3_parent_ancestry_qualified(Person),
    section3_parent_residence_before_birth(Person).

% Section 3(2)-(3)(a)-(b): a stateless overseas-born applicant meets the ancestry
% requirements without the subsection (3)(c) residence requirement.
section3_entitled_under_subsection_2(Person) :-
    fact(Person, born_outside_uk, true),
    fact(Person, born_stateless, true),
    fact(Person, registration_application, true),
    section3_application_is_timely(Person),
    section3_parent_ancestry_qualified(Person).

% Section 3(5)(a): a minor applicant has a parent who was a citizen by descent at birth.
section3_five_qualifying_parent(Person) :-
    fact(Person, parent_is_citizen_by_descent, true).

% Section 3(5)(b): the applicant and family meet the three-year residence test.
section3_five_requirements(Person) :-
    fact(Person, section3_parent_in_uk_at_start, true),
    fact(Person, section3_parent_absence_days, Days),
    Days =< 270.

% Section 3(5): a minor overseas-born applicant qualifies when the descent,
% residence, and consent requirements are met.
section3_entitled_under_subsection_5(Person) :-
    fact(Person, born_outside_uk, true),
    fact(Person, minor_at_application, true),
    fact(Person, registration_application, true),
    section3_five_qualifying_parent(Person),
    section3_five_requirements(Person),
    fact(Person, parents_consent_to_registration, true).
