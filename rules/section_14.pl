:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

:- discontiguous section14_by_descent/1.

% Section 14(1)(a): post-commencement overseas birth under section 2(1)(a) alone is by descent.
section14_by_descent(Person) :-
    fact(Person, section14_citizenship_basis, section2_1_a_only),
    fact(Person, born_outside_uk, true),
    fact(Person, after_commencement, true).

% Section 14(1)(a): post-commencement overseas birth followed by section 3(2) registration is by descent.
section14_by_descent(Person) :-
    fact(Person, section14_citizenship_basis, section3_2_registration),
    fact(Person, born_outside_uk, true),
    fact(Person, after_commencement, true).

% Section 14(1)(a): post-commencement overseas birth followed by section 9 registration is by descent.
section14_by_descent(Person) :-
    fact(Person, section14_citizenship_basis, section9_registration),
    fact(Person, born_outside_uk, true),
    fact(Person, after_commencement, true).

% Section 14(1)(c)(i): section 3(1) registration is by descent where a parent was British at birth.
section14_by_descent(Person) :-
    fact(Person, section14_citizenship_basis, section3_1_registration),
    fact(Person, section14_parent_british_at_birth, true).

% Section 14(1)(c)(ii): section 3(1) registration is by descent where a parent became British at commencement or would but for death.
section14_by_descent(Person) :-
    fact(Person, section14_citizenship_basis, section3_1_registration),
    fact(Person, section14_parent_cukc_became_british_or_would_but_for_death, true).

% Section 14(1)(d): registration under section 5 is classified as by descent.
section14_by_descent(Person) :-
    fact(Person, section14_citizenship_basis, section5_registration).

% Section 14(1)(f): section 10 registration following pre-commencement renunciation may preserve the descent classification.
section14_by_descent(Person) :-
    fact(Person, section14_citizenship_basis, section10_registration),
    fact(Person, section14_would_have_been_descent_but_for_precommencement_renunciation, true).

% Section 14(1)(g): section 13 resumption preserves the classification held immediately before renunciation.
section14_by_descent(Person) :-
    fact(Person, section14_citizenship_basis, section13_registration),
    fact(Person, section14_was_by_descent_immediately_before_renunciation, true).

% Section 14(1)(h): dependent-territory birth citizenship under Schedule 2 paragraph 2 is by descent.
section14_by_descent(Person) :-
    fact(Person, section14_citizenship_basis, schedule2_paragraph2).

% Section 14(1)(b), (e): a qualifying legacy route supplies a descent candidate before applying the service exception.
section14_rule_candidate(Person, section14, by_descent, s14_legacy_descent) :-
    section14_legacy_birth_route(Person).

% Section 14(1)(e): the legacy marriage route also supplies a descent candidate before resolving subsection (2).
section14_rule_candidate(Person, section14, by_descent, s14_legacy_descent) :-
    section14_legacy_section8_route(Person).

% Section 14(2): qualifying service supplies the competing outcome for a covered historic route.
section14_rule_candidate(Person, section14, not_by_descent, s14_service_exception) :-
    section14_legacy_birth_route(Person),
    section14_service_exception(Person).

% Section 14(2): service also defeats descent on the historic section 8 marriage route.
section14_rule_candidate(Person, section14, not_by_descent, s14_service_exception) :-
    section14_legacy_section8_route(Person),
    section14_service_exception(Person).

% Section 14(2): service exception has priority over the ordinary historic descent classification.
section14_rule_priority(section14, s14_service_exception, 20).

% Section 14(1)(b), (e): legacy descent has lower priority than the subsection (2) service exception.
section14_rule_priority(section14, s14_legacy_descent, 10).

% Section 14(1)-(2): by-descent and not-by-descent are competing classifications for these historic routes.
section14_rule_conflict(section14, by_descent, not_by_descent).

% Section 14(1)(b), (e), (2): accept historic descent only after resolving any applicable service exception.
section14_by_descent(Person) :-
    section14_accepted_outcome(Person, section14, by_descent).

% Section 14(2): report the higher-priority service outcome for the legacy routes.
section14_not_by_descent(Person) :-
    section14_accepted_outcome(Person, section14, not_by_descent).

% Section 14(1)(b): the specified pre-commencement status and 1948-1965 Act conditions are input as a historical-law determination.
section14_legacy_birth_route(Person) :-
    fact(Person, born_outside_uk, true),
    fact(Person, before_commencement, true),
    fact(Person, section14_subsection_1_b_historic_conditions_met, true).

% Section 14(1)(e): the specified pre-commencement overseas-born woman's section 8 marriage registration is a historic descent route.
section14_legacy_section8_route(Person) :-
    fact(Person, born_outside_uk, true),
    fact(Person, before_commencement, true),
    fact(Person, section14_subsection_1_e_historic_conditions_met, true).

% Section 14(2)-(3)(a): Crown service, overseas service, and recruitment in the UK create the historical exception.
section14_service_exception(Person) :-
    fact(Person, section14_father_served_outside_uk_at_birth, true),
    fact(Person, section14_father_service_type, uk_crown),
    fact(Person, section14_service_recruited_in_uk, true).

% Section 14(2)-(3)(a): service designated under section 2(3), recruitment in the UK, and overseas service create the exception.
section14_service_exception(Person) :-
    fact(Person, section14_father_served_outside_uk_at_birth, true),
    fact(Person, section14_father_service_type, uk_designated_service),
    fact(Person, section14_service_recruited_in_uk, true).

% Section 14(2)(b): Community-institution service with recruitment in a then-member country creates the historical exception.
section14_service_exception(Person) :-
    fact(Person, section14_father_served_outside_uk_at_birth, true),
    fact(Person, section14_father_service_type, community_institution),
    fact(Person, section14_service_recruited_in_member_country_at_recruitment, true).

% Section 14(1)-(2): qualifying service defeats the lower-ranked legacy descent candidate.
section14_rule_defeats(Person, Section, LowerRule, HigherRule) :-
    section14_rule_candidate(Person, Section, LowerOutcome, LowerRule),
    section14_rule_candidate(Person, Section, HigherOutcome, HigherRule),
    section14_rule_conflicts(Section, LowerOutcome, HigherOutcome),
    section14_rule_priority(Section, LowerRule, LowerRank),
    section14_rule_priority(Section, HigherRule, HigherRank),
    HigherRank > LowerRank.

% Section 14(1)-(2): conflicts apply in either candidate ordering.
section14_rule_conflicts(Section, Outcome, OtherOutcome) :-
    section14_rule_conflict(Section, Outcome, OtherOutcome).
section14_rule_conflicts(Section, Outcome, OtherOutcome) :-
    section14_rule_conflict(Section, OtherOutcome, Outcome).

% Section 14(1)-(2): record a candidate only when an applicable priority defeat exists.
section14_rule_defeated(Person, Section, Rule) :-
    section14_rule_defeats(Person, Section, Rule, _HigherRule).

% Section 14(1)-(2): accept a descent classification only after rejecting defeated rules.
section14_accepted_outcome(Person, Section, Outcome) :-
    section14_rule_candidate(Person, Section, Outcome, Rule),
    not section14_rule_defeated(Person, Section, Rule).
