:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

% Section 24, applying section 12(5): full age includes a person who has been married.
section24_full_age_requirement(Person) :-
    fact(Person, full_age, true).

% Section 24, applying section 12(5): a person who has been married is deemed to meet the age requirement.
section24_full_age_requirement(Person) :-
    fact(Person, has_been_married, true).

% Section 24, applying section 12(1): the declaration route is scoped to BDT citizens and requires full capacity, statutory age and prescribed form.
section24_declaration_requirements(Person) :-
    fact(Person, bdt_citizen, true),
    section24_full_age_requirement(Person),
    fact(Person, full_capacity, true),
    fact(Person, section24_declaration_made_in_prescribed_manner, true).

% Section 24, applying section 12(3): the Secretary of State must be satisfied that another nationality will be held or acquired after registration.
section24_other_nationality_safeguard(Person) :-
    fact(Person, section24_secretary_satisfied_other_nationality_will_be_held_or_acquired, true).

% Section 24, applying section 12(1), (3): an otherwise valid declaration supplies a BDT registration candidate.
section24_rule_candidate(Person, section24, declaration_registered, s24_ordinary_registration) :-
    section24_declaration_requirements(Person),
    section24_other_nationality_safeguard(Person).

% Section 24, applying section 12(4): wartime withholding supplies an opposing BDT registration candidate.
section24_rule_candidate(Person, section24, declaration_withheld, s24_wartime_withholding) :-
    fact(Person, section24_made_during_qualifying_war, true),
    fact(Person, section24_secretary_withholds_registration, true).

% Section 24, applying section 12(4): wartime withholding has priority over ordinary BDT declaration registration.
section24_rule_priority(section24, s24_wartime_withholding, 20).

% Section 24, applying section 12(1): ordinary BDT declaration registration has lower priority than wartime withholding.
section24_rule_priority(section24, s24_ordinary_registration, 10).

% Section 24, applying section 12(1), (4): registration and wartime withholding are incompatible outcomes.
section24_rule_conflict(section24, declaration_registered, declaration_withheld).

% Section 24, applying section 12(4): expose the applicable wartime candidate for explanations and tests.
section24_wartime_withholding_applies(Person) :-
    section24_rule_candidate(Person, section24, declaration_withheld, s24_wartime_withholding).

% Section 24, applying section 12(1), (3)-(4): resolve competing registration and withholding candidates by priority.
section24_declaration_registered(Person) :-
    section24_accepted_outcome(Person, section24, declaration_registered).

% Section 24, applying section 12(4): report the withholding outcome selected over registration.
section24_declaration_withheld(Person) :-
    section24_accepted_outcome(Person, section24, declaration_withheld).

% Section 24, applying section 12(1), (4): ordinary registration survives exactly when accepted by priority resolution.
section24_registration_not_withheld(Person) :-
    section24_declaration_registered(Person).

% Section 24, applying section 12(2)-(3): a registered BDT-citizen declaration causes cessation when another nationality is held at registration.
section24_ceases_to_be_bdt_citizen(Person) :-
    section24_declaration_registered(Person),
    fact(Person, section24_other_nationality_held_at_registration, true).

% Section 24, applying section 12(2)-(3): acquiring another nationality within six months causes cessation.
section24_ceases_to_be_bdt_citizen(Person) :-
    section24_declaration_registered(Person),
    fact(Person, section24_acquired_other_nationality_within_six_months, true).

% Section 24, applying section 12(3): BDT citizenship is retained if neither other nationality was held at registration nor acquired within six months.
section24_remains_bdt_citizen(Person) :-
    section24_declaration_registered(Person),
    fact(Person, section24_other_nationality_held_at_registration, false),
    fact(Person, section24_acquired_other_nationality_within_six_months, false).

% Section 24, applying section 13(1): mandatory resumption requires prior BDT-citizenship renunciation, full capacity and application.
section24_basic_resumption_requirements(Person) :-
    fact(Person, section24_ceased_bdt_citizen_by_renunciation, true),
    fact(Person, full_capacity, true),
    fact(Person, registration_application, true).

% Section 24, applying section 13(2): mandatory resumption is unavailable after a prior subsection (1) registration.
section24_once_only_requirement(Person) :-
    fact(Person, section24_prior_subsection_13_1_registration, false).

% Section 24, applying section 13(1)(b), (2): entitlement requires necessary renunciation and is available only once.
section24_entitled_to_resumption_registration(Person) :-
    section24_basic_resumption_requirements(Person),
    fact(Person, section24_renunciation_necessary_for_other_nationality, true),
    section24_once_only_requirement(Person).

% Section 24, applying section 13(3): the Secretary of State may register a full-capacity former BDT citizen regardless of why renunciation occurred.
section24_may_register_on_resumption(Person) :-
    fact(Person, section24_ceased_bdt_citizen_by_renunciation, true),
    fact(Person, full_capacity, true),
    fact(Person, registration_application, true),
    fact(Person, secretary_of_state_approves_registration, true).

% Section 24, applying section 12(1), (4): wartime withholding defeats ordinary declaration registration.
section24_rule_defeats(Person, Section, LowerRule, HigherRule) :-
    section24_rule_candidate(Person, Section, LowerOutcome, LowerRule),
    section24_rule_candidate(Person, Section, HigherOutcome, HigherRule),
    section24_rule_conflicts(Section, LowerOutcome, HigherOutcome),
    section24_rule_priority(Section, LowerRule, LowerRank),
    section24_rule_priority(Section, HigherRule, HigherRank),
    HigherRank > LowerRank.

% Section 24, applying section 12(1), (4): conflicts apply in either candidate ordering.
section24_rule_conflicts(Section, Outcome, OtherOutcome) :-
    section24_rule_conflict(Section, Outcome, OtherOutcome).
section24_rule_conflicts(Section, Outcome, OtherOutcome) :-
    section24_rule_conflict(Section, OtherOutcome, Outcome).

% Section 24, applying section 12(1), (4): record a candidate only when an applicable defeat exists.
section24_rule_defeated(Person, Section, Rule) :-
    section24_rule_defeats(Person, Section, Rule, _HigherRule).

% Section 24, applying section 12(1), (4): accept an outcome only after rejecting defeated rules.
section24_accepted_outcome(Person, Section, Outcome) :-
    section24_rule_candidate(Person, Section, Outcome, Rule),
    not section24_rule_defeated(Person, Section, Rule).
