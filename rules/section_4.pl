:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

:- discontiguous section4_may_register_by_service/1.

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

% Section 4(2)(a): no more than 450 days supplies the ordinary satisfied five-year absence candidate.
section4_rule_candidate(Person, section4, met(five_year_absence), s4_ordinary_absence_limit) :-
    fact(Person, section4_absence_days_five_years, Days),
    Days >= 0,
    Days =< 450.

% Section 4(2)(a): more than 450 days supplies the ordinary failed five-year absence candidate.
section4_rule_candidate(Person, section4, not_met(five_year_absence), s4_ordinary_absence_limit) :-
    fact(Person, section4_absence_days_five_years, Days),
    Days > 450.

% Section 4(4)(a): special circumstances supply a competing satisfied five-year absence candidate.
section4_rule_candidate(Person, section4, met(five_year_absence), s4_special_absence_relief) :-
    fact(Person, section4_special_relief, five_year_absence),
    fact(Person, section4_absence_days_five_years, Days),
    Days > 450.

% Section 4(2)(b): no more than 90 days supplies the ordinary satisfied final-year absence candidate.
section4_rule_candidate(Person, section4, met(last_year_absence), s4_ordinary_absence_limit) :-
    fact(Person, section4_absence_days_last_twelve_months, Days),
    Days >= 0,
    Days =< 90.

% Section 4(2)(b): more than 90 days supplies the ordinary failed final-year absence candidate.
section4_rule_candidate(Person, section4, not_met(last_year_absence), s4_ordinary_absence_limit) :-
    fact(Person, section4_absence_days_last_twelve_months, Days),
    Days > 90.

% Section 4(4)(a): special circumstances supply a competing satisfied final-year absence candidate.
section4_rule_candidate(Person, section4, met(last_year_absence), s4_special_absence_relief) :-
    fact(Person, section4_special_relief, last_twelve_months_absence),
    fact(Person, section4_absence_days_last_twelve_months, Days),
    Days > 90.

% Section 4(2)(c): no restriction during the final year supplies the satisfied ordinary candidate.
section4_rule_candidate(Person, section4, met(immigration_restriction), s4_ordinary_immigration_rule) :-
    fact(Person, section4_restricted_during_last_twelve_months, false).

% Section 4(2)(c): a final-year restriction supplies the failed ordinary candidate.
section4_rule_candidate(Person, section4, not_met(immigration_restriction), s4_ordinary_immigration_rule) :-
    fact(Person, section4_restricted_during_last_twelve_months, true).

% Section 4(4)(b): special circumstances supply a competing satisfied candidate for a past restriction only.
section4_rule_candidate(Person, section4, met(immigration_restriction), s4_special_immigration_relief) :-
    fact(Person, section4_restricted_during_last_twelve_months, true),
    fact(Person, section4_restriction_applies_on_application_date, false),
    fact(Person, section4_special_relief, past_immigration_restriction).

% Section 4(2)(d): no breach during the five-year period supplies the satisfied ordinary candidate.
section4_rule_candidate(Person, section4, met(immigration_compliance), s4_ordinary_immigration_rule) :-
    fact(Person, section4_in_uk_in_breach_during_five_years, false).

% Section 4(2)(d): a breach during the five-year period supplies the failed ordinary candidate.
section4_rule_candidate(Person, section4, not_met(immigration_compliance), s4_ordinary_immigration_rule) :-
    fact(Person, section4_in_uk_in_breach_during_five_years, true).

% Section 4(4)(c): special circumstances supply a competing satisfied candidate for an immigration breach.
section4_rule_candidate(Person, section4, met(immigration_compliance), s4_special_immigration_relief) :-
    fact(Person, section4_in_uk_in_breach_during_five_years, true),
    fact(Person, section4_special_relief, immigration_breach).

% Section 4(4): special-circumstances relief defeats a conflicting ordinary residence or immigration result.
section4_rule_priority(section4, s4_special_absence_relief, 20).

% Section 4(4): special immigration relief defeats a conflicting ordinary restriction or compliance result.
section4_rule_priority(section4, s4_special_immigration_relief, 20).

% Section 4(2): ordinary residence and immigration tests have lower priority than statutory subsection (4) relief.
section4_rule_priority(section4, s4_ordinary_absence_limit, 10).

% Section 4(2): ordinary immigration requirements have lower priority than statutory subsection (4) relief.
section4_rule_priority(section4, s4_ordinary_immigration_rule, 10).

% Section 4(2)(a), (4)(a): satisfying and failing the five-year absence limit are incompatible outcomes.
section4_rule_conflict(section4, met(five_year_absence), not_met(five_year_absence)).

% Section 4(2)(b), (4)(a): satisfying and failing the final-year absence limit are incompatible outcomes.
section4_rule_conflict(section4, met(last_year_absence), not_met(last_year_absence)).

% Section 4(2)(c), (4)(b): satisfying and failing the restriction condition are incompatible outcomes.
section4_rule_conflict(section4, met(immigration_restriction), not_met(immigration_restriction)).

% Section 4(2)(d), (4)(c): satisfying and failing the immigration-compliance condition are incompatible outcomes.
section4_rule_conflict(section4, met(immigration_compliance), not_met(immigration_compliance)).

% Section 4(2)(a), (4)(a): the requirement is met only when that outcome survives priority resolution.
section4_five_year_absence_requirement(Person) :-
    section4_accepted_outcome(Person, section4, met(five_year_absence)).

% Section 4(2)(b), (4)(a): the requirement is met only when that outcome survives priority resolution.
section4_last_year_absence_requirement(Person) :-
    section4_accepted_outcome(Person, section4, met(last_year_absence)).

% Section 4(2)(c), (4)(b): the requirement is met only when that outcome survives priority resolution.
section4_immigration_restriction_requirement(Person) :-
    section4_accepted_outcome(Person, section4, met(immigration_restriction)).

% Section 4(2)(d), (4)(c): the requirement is met only when that outcome survives priority resolution.
section4_immigration_compliance_requirement(Person) :-
    section4_accepted_outcome(Person, section4, met(immigration_compliance)).

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

% Section 4(2), (4): an applicable incompatible relief candidate defeats a lower-ranked requirement rule.
section4_rule_defeats(Person, Section, LowerRule, HigherRule) :-
    section4_rule_candidate(Person, Section, LowerOutcome, LowerRule),
    section4_rule_candidate(Person, Section, HigherOutcome, HigherRule),
    section4_rule_conflicts(Section, LowerOutcome, HigherOutcome),
    section4_rule_priority(Section, LowerRule, LowerRank),
    section4_rule_priority(Section, HigherRule, HigherRank),
    HigherRank > LowerRank.

% Section 4(2), (4): conflicts apply in either candidate ordering.
section4_rule_conflicts(Section, Outcome, OtherOutcome) :-
    section4_rule_conflict(Section, Outcome, OtherOutcome).
section4_rule_conflicts(Section, Outcome, OtherOutcome) :-
    section4_rule_conflict(Section, OtherOutcome, Outcome).

% Section 4(2), (4): record a requirement rule only when an applicable defeat exists.
section4_rule_defeated(Person, Section, Rule) :-
    section4_rule_defeats(Person, Section, Rule, _HigherRule).

% Section 4(2), (4): accept a requirement candidate only after rejecting defeated rules.
section4_accepted_outcome(Person, Section, Outcome) :-
    section4_rule_candidate(Person, Section, Outcome, Rule),
    not section4_rule_defeated(Person, Section, Rule).

% Section 4(5)-(6): service on a statutory body in a dependent territory is a qualifying service category.
section4_may_register_by_service(Person) :-
    section4_application(Person),
    fact(Person, section4_qualifying_service, dependent_territory_crown_body),
    fact(Person, section4_special_circumstances_approval, true).
