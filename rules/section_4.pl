:- use_module(library(scasp)).
:- use_module('../facts/rdf_facts.pl').

% Section 4(1): a British Dependent Territories citizen is within the covered group.
section4_covered_person(Person) :-
    fact(Person, section4_status, bdt_citizen).

% Section 4(1): a British Overseas citizen is within the covered group.
section4_covered_person(Person) :-
    fact(Person, section4_status, british_overseas_citizen).

% Section 4(1): a British subject under the Act is within the covered group.
section4_covered_person(Person) :-
    fact(Person, section4_status, british_subject_under_act).

% Section 4(1): a British protected person is within the covered group.
section4_covered_person(Person) :-
    fact(Person, section4_status, british_protected_person).

% Section 4(2): the ordinary five-year residence route requires an application by a covered person.
section4_application(Person) :-
    section4_covered_person(Person),
    fact(Person, registration_application, true).

% Section 4(2)(a): presence at the start of the five-year period is required ordinarily.
section4_five_year_start_requirement(Person) :-
    fact(Person, section4_in_uk_at_five_year_period_start, true).

% Section 4(3): prior settlement removes the five-year period-start presence requirement.
section4_five_year_start_requirement(Person) :-
    fact(Person, section4_settled_in_uk_immediately_before_commencement, true).

% Section 4(4): special-circumstances relief has priority over the ordinary absence limits.
section4_priority(s4_special_absence_relief, 20).

% Section 4(2): ordinary absence limits have lower priority than the special-circumstances relief.
section4_priority(s4_ordinary_absence_limits, 10).

% Sections 4(2) and 4(4): the numeric order records which rule prevails for absence-limit relief.
section4_higher_priority(HigherRule, LowerRule) :-
    section4_priority(HigherRule, HigherRank),
    section4_priority(LowerRule, LowerRank),
    HigherRank > LowerRank.

% Section 4(2)(a): no more than 450 days of absence meets the five-year absence limit.
section4_five_year_absence_requirement(Person) :-
    fact(Person, section4_absence_days_five_years, Days),
    Days >= 0,
    Days =< 450.

% Section 4(4)(a): the Secretary of State may treat either absence limit as met in special circumstances.
section4_five_year_absence_requirement(Person) :-
    fact(Person, section4_special_relief, five_year_absence),
    section4_higher_priority(s4_special_absence_relief, s4_ordinary_absence_limits).

% Section 4(2)(b): no more than 90 days of absence meets the final-year absence limit.
section4_last_year_absence_requirement(Person) :-
    fact(Person, section4_absence_days_last_twelve_months, Days),
    Days >= 0,
    Days =< 90.

% Section 4(4)(a): the Secretary of State may treat the final-year absence limit as met in special circumstances.
section4_last_year_absence_requirement(Person) :-
    fact(Person, section4_special_relief, last_twelve_months_absence),
    section4_higher_priority(s4_special_absence_relief, s4_ordinary_absence_limits).

% Section 4(2)(c): no immigration restriction during the final year meets the restriction requirement.
section4_immigration_restriction_requirement(Person) :-
    fact(Person, section4_restricted_during_last_twelve_months, false).

% Section 4(4)(b): special circumstances may permit disregard of an earlier restriction, not one current on application.
section4_immigration_restriction_requirement(Person) :-
    fact(Person, section4_restricted_during_last_twelve_months, true),
    fact(Person, section4_restriction_applies_on_application_date, false),
    fact(Person, section4_special_relief, past_immigration_restriction),
    section4_higher_priority(s4_special_absence_relief, s4_ordinary_absence_limits).

% Section 4(2)(d): no breach of immigration law during the five-year period meets the compliance requirement.
section4_immigration_compliance_requirement(Person) :-
    fact(Person, section4_in_uk_in_breach_during_five_years, false).

% Section 4(2)(d): a breach during the five-year period otherwise defeats the compliance requirement.
section4_immigration_compliance_requirement(Person) :-
    fact(Person, section4_in_uk_in_breach_during_five_years, true),
    fact(Person, section4_special_relief, immigration_breach),
    section4_higher_priority(s4_special_absence_relief, s4_ordinary_absence_limits).

% Section 4(2): the ordinary registration entitlement requires all residence, immigration, and application conditions.
section4_entitled_to_registration(Person) :-
    section4_application(Person),
    section4_five_year_start_requirement(Person),
    section4_five_year_absence_requirement(Person),
    section4_last_year_absence_requirement(Person),
    section4_immigration_restriction_requirement(Person),
    section4_immigration_compliance_requirement(Person).

% Section 4(5)-(6): special service and special circumstances allow the Secretary of State to register a covered applicant.
section4_may_register_by_service(Person) :-
    section4_application(Person),
    fact(Person, section4_qualifying_service, dependent_territory_crown),
    fact(Person, section4_special_circumstances_approval, true).

% Section 4(5)-(6): service on a statutory body in a dependent territory is a qualifying service category.
section4_may_register_by_service(Person) :-
    section4_application(Person),
    fact(Person, section4_qualifying_service, dependent_territory_crown_body),
    fact(Person, section4_special_circumstances_approval, true).
