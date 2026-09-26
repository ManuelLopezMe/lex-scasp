:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

:- discontiguous section25_ordinary_descent_basis/1.
:- discontiguous section25_historical_descent_basis/1.
:- discontiguous section25_by_descent/1.

% Section 25(1)(a): citizenship acquired by section 16(1)(a) only after overseas birth is by descent.
section25_ordinary_descent_basis(Person) :-
    fact(Person, section25_citizenship_basis, section16_1_a_only),
    fact(Person, born_outside_dependent_territories, true),
    fact(Person, after_commencement, true).

% Section 25(1)(a): citizenship by registration under section 17(2) is by descent.
section25_ordinary_descent_basis(Person) :-
    fact(Person, section25_citizenship_basis, section17_2_registration).

% Section 25(1)(a): citizenship by registration under section 21 is by descent.
section25_ordinary_descent_basis(Person) :-
    fact(Person, section25_citizenship_basis, section21_registration).

% Section 25(1)(b)(i): the specified pre-commencement section 5 CUKC descent status creates the historical descent route.
section25_historical_descent_basis(Person) :-
    fact(Person, section25_citizenship_basis, section23_commencement),
    fact(Person, born_outside_dependent_territories, true),
    fact(Person, before_commencement, true),
    fact(Person, section25_cukc_by_1948_act_section_5_descent, true).

% Section 25(1)(b)(ii): the specified deemed-descent-only status, including the statutory female equivalent, creates the historical route.
section25_historical_descent_basis(Person) :-
    fact(Person, section25_citizenship_basis, section23_commencement),
    fact(Person, born_outside_dependent_territories, true),
    fact(Person, before_commencement, true),
    fact(Person, section25_cukc_deemed_descent_only_or_would_if_female, true).

% Section 25(1)(c)(i): section 17(1) registration is by descent when a parent was a BDT citizen at birth.
section25_ordinary_descent_basis(Person) :-
    fact(Person, section25_citizenship_basis, section17_1_registration),
    fact(Person, section25_parent_bdt_citizen_at_birth, true).

% Section 25(1)(c)(ii): section 17(1) registration is by descent when a CUKC parent at birth became a BDT citizen at commencement or would but for death.
section25_ordinary_descent_basis(Person) :-
    fact(Person, section25_citizenship_basis, section17_1_registration),
    fact(Person, section25_parent_cukc_at_birth_became_bdt_at_commencement_or_would_but_for_death, true).

% Section 25(1)(d): citizenship under section 23(1)(b) only is a historical descent route.
section25_historical_descent_basis(Person) :-
    fact(Person, section25_citizenship_basis, section23_1_b_only),
    fact(Person, born_outside_dependent_territories, true),
    fact(Person, before_commencement, true).

% Section 25(1)(e): a woman's section 23(1)(c)-only status through a BDT husband by descent under (b) or (d) is a historical descent route.
section25_historical_descent_basis(Person) :-
    fact(Person, section25_citizenship_basis, section23_1_c_only),
    fact(Person, section25_woman_became_bdt_at_commencement_only_through_marriage, true),
    fact(Person, section25_husband_bdt_by_descent_under_1_b_or_d_or_would_but_for_death, true).

% Section 25(1)(f): a woman's pre-commencement overseas birth and section 20 marriage registration through a BDT husband by descent is a historical descent route.
section25_historical_descent_basis(Person) :-
    fact(Person, section25_citizenship_basis, section20_registration),
    fact(Person, born_outside_dependent_territories, true),
    fact(Person, before_commencement, true),
    fact(Person, section25_husband_bdt_by_descent_at_commencement_or_would_but_for_death_or_cukc_renunciation, true).

% Section 25(1)(g): section 22 resumption after renunciation is by descent if the person would have qualified at commencement under (b), (d) or (e).
section25_historical_descent_basis(Person) :-
    fact(Person, section25_citizenship_basis, section22_registration_after_renunciation),
    fact(Person, section25_would_be_bdt_by_descent_at_commencement_under_1_b_d_or_e_but_for_renunciation, true).

% Section 25(1)(h): section 13 resumption as applied by section 24 preserves the immediately preceding BDT descent classification.
section25_ordinary_descent_basis(Person) :-
    fact(Person, section25_citizenship_basis, section24_section13_registration),
    fact(Person, section25_was_bdt_by_descent_immediately_before_renunciation, true).

% Section 25(1)(i): UK birth after commencement and Schedule 2 paragraph 1 citizenship is by descent.
section25_ordinary_descent_basis(Person) :-
    fact(Person, section25_citizenship_basis, schedule2_paragraph1),
    fact(Person, born_in_uk, true),
    fact(Person, after_commencement, true).

% Section 25(2): a father serving outside the territories in dependent-territory Crown service recruited there triggers the exception.
section25_service_exception(Person) :-
    fact(Person, born_outside_dependent_territories, true),
    fact(Person, before_commencement, true),
    fact(Person, section25_father_serving_outside_dependent_territories_at_birth, true),
    fact(Person, section25_father_service_type, dependent_territory_crown),
    fact(Person, section25_father_recruited_in_dependent_territory, true).

% Section 25(2)-(3): designated service recruited in a dependent territory triggers the exception only on an express designation input.
section25_service_exception(Person) :-
    fact(Person, born_outside_dependent_territories, true),
    fact(Person, before_commencement, true),
    fact(Person, section25_father_serving_outside_dependent_territories_at_birth, true),
    fact(Person, section25_father_service_type, designated_service),
    fact(Person, section25_service_description_designated_under_section16_3, true),
    fact(Person, section25_father_recruited_in_dependent_territory, true).

% Section 25(1)(b), (d)-(f): each historic route supplies a descent candidate before subsection (2) is resolved.
section25_rule_candidate(Person, section25, by_descent, s25_historical_descent) :-
    section25_historical_descent_basis(Person).

% Section 25(2): qualifying service supplies a competing non-descent candidate for the subsection (1)(b), (d)-(f) routes.
section25_rule_candidate(Person, section25, not_by_descent, s25_service_exception) :-
    section25_historical_descent_basis(Person),
    section25_service_exception(Person).

% Section 25(2): the service exception has priority over historical descent classification.
section25_rule_priority(section25, s25_service_exception, 20).

% Section 25(1)(b), (d)-(f): historical descent has lower priority than the subsection (2) service exception.
section25_rule_priority(section25, s25_historical_descent, 10).

% Section 25(1)-(2): descent and non-descent are competing classifications for the named historical routes.
section25_rule_conflict(section25, by_descent, not_by_descent).

% Section 25(1)(b), (d)-(f), (2): resolve the historical descent and service-exception candidates.
section25_by_descent(Person) :-
    section25_accepted_outcome(Person, section25, by_descent).

% Section 25(2): report when the service exception defeats the historical descent candidate.
section25_not_by_descent(Person) :-
    section25_accepted_outcome(Person, section25, not_by_descent).

% Section 25(1): the remaining statutory acquisition and registration routes are by descent without the subsection (2) historical exception.
section25_by_descent(Person) :-
    section25_ordinary_descent_basis(Person).

% Section 25(1)-(2): the applicable service exception defeats lower-ranked historic descent.
section25_rule_defeats(Person, Section, LowerRule, HigherRule) :-
    section25_rule_candidate(Person, Section, LowerOutcome, LowerRule),
    section25_rule_candidate(Person, Section, HigherOutcome, HigherRule),
    section25_rule_conflicts(Section, LowerOutcome, HigherOutcome),
    section25_rule_priority(Section, LowerRule, LowerRank),
    section25_rule_priority(Section, HigherRule, HigherRank),
    HigherRank > LowerRank.

% Section 25(1)-(2): conflicts apply in either candidate ordering.
section25_rule_conflicts(Section, Outcome, OtherOutcome) :-
    section25_rule_conflict(Section, Outcome, OtherOutcome).
section25_rule_conflicts(Section, Outcome, OtherOutcome) :-
    section25_rule_conflict(Section, OtherOutcome, Outcome).

% Section 25(1)-(2): record a candidate only when an applicable priority defeat exists.
section25_rule_defeated(Person, Section, Rule) :-
    section25_rule_defeats(Person, Section, Rule, _HigherRule).

% Section 25(1)-(2): accept a descent classification only after rejecting defeated rules.
section25_accepted_outcome(Person, Section, Outcome) :-
    section25_rule_candidate(Person, Section, Outcome, Rule),
    not section25_rule_defeated(Person, Section, Rule).
