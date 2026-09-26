:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

% Section 29, applying Section 12(5): full age includes a person who has been married.
section29_full_age_requirement(Person) :-
    fact(Person, full_age, true).

% Section 29, applying Section 12(5): a person who has been married is deemed to meet the age requirement.
section29_full_age_requirement(Person) :-
    fact(Person, has_been_married, true).

% Section 29, applying Section 12(1): a valid BOC declaration requires BOC status, full capacity, statutory age and prescribed form.
section29_declaration_requirements(Person) :-
    fact(Person, british_overseas_citizen, true),
    section29_full_age_requirement(Person),
    fact(Person, full_capacity, true),
    fact(Person, section29_declaration_made_in_prescribed_manner, true).

% Section 29, applying Section 12(3): the Secretary of State must be satisfied that another nationality will be held or acquired after registration.
section29_other_nationality_safeguard(Person) :-
    fact(Person, section29_secretary_satisfied_other_nationality_will_be_held_or_acquired, true).

% Section 29, applying Section 12(1), (3): an otherwise valid BOC declaration supplies a registration candidate.
section29_rule_candidate(Person, section29, declaration_registered, s29_ordinary_registration) :-
    section29_declaration_requirements(Person),
    section29_other_nationality_safeguard(Person).

% Section 29, applying Section 12(4): wartime withholding supplies an opposing BOC registration candidate.
section29_rule_candidate(Person, section29, declaration_withheld, s29_wartime_withholding) :-
    fact(Person, section29_made_during_qualifying_war, true),
    fact(Person, section29_secretary_withholds_registration, true).

% Section 29, applying Section 12(4): wartime withholding has priority over ordinary BOC declaration registration.
section29_rule_priority(section29, s29_wartime_withholding, 20).

% Section 29, applying Section 12(1): ordinary BOC declaration registration has lower priority than wartime withholding.
section29_rule_priority(section29, s29_ordinary_registration, 10).

% Section 29, applying Sections 12(1), 12(4): registration and wartime withholding are incompatible outcomes.
section29_rule_conflict(section29, declaration_registered, declaration_withheld).

% Section 29, applying Section 12(4): expose the applicable wartime candidate for explanations and tests.
section29_wartime_withholding_applies(Person) :-
    section29_rule_candidate(Person, section29, declaration_withheld, s29_wartime_withholding).

% Section 29, applying Sections 12(1), 12(3)-(4): resolve the opposing BOC registration and withholding candidates.
section29_declaration_registered(Person) :-
    section29_accepted_outcome(Person, section29, declaration_registered).

% Section 29, applying Section 12(4): report the withholding outcome selected over registration.
section29_declaration_withheld(Person) :-
    section29_accepted_outcome(Person, section29, declaration_withheld).

% Section 29, applying Sections 12(1), 12(4): registration survives exactly when accepted by priority resolution.
section29_registration_not_withheld(Person) :-
    section29_declaration_registered(Person).

% Section 29, applying Section 12(2)-(3): a registered BOC declaration causes cessation when another nationality is held at registration.
section29_ceases_to_be_boc(Person) :-
    section29_declaration_registered(Person),
    fact(Person, section29_other_nationality_held_at_registration, true).

% Section 29, applying Section 12(2)-(3): acquiring another nationality within six months causes cessation.
section29_ceases_to_be_boc(Person) :-
    section29_declaration_registered(Person),
    fact(Person, section29_acquired_other_nationality_within_six_months, true).

% Section 29, applying Section 12(3): BOC status is retained if neither other nationality was held at registration nor acquired within six months.
section29_remains_boc(Person) :-
    section29_declaration_registered(Person),
    fact(Person, section29_other_nationality_held_at_registration, false),
    fact(Person, section29_acquired_other_nationality_within_six_months, false).

% Section 29, applying section 12(1), (4): wartime withholding defeats ordinary declaration registration.
section29_rule_defeats(Person, Section, LowerRule, HigherRule) :-
    section29_rule_candidate(Person, Section, LowerOutcome, LowerRule),
    section29_rule_candidate(Person, Section, HigherOutcome, HigherRule),
    section29_rule_conflicts(Section, LowerOutcome, HigherOutcome),
    section29_rule_priority(Section, LowerRule, LowerRank),
    section29_rule_priority(Section, HigherRule, HigherRank),
    HigherRank > LowerRank.

% Section 29, applying section 12(1), (4): conflicts apply in either candidate ordering.
section29_rule_conflicts(Section, Outcome, OtherOutcome) :-
    section29_rule_conflict(Section, Outcome, OtherOutcome).
section29_rule_conflicts(Section, Outcome, OtherOutcome) :-
    section29_rule_conflict(Section, OtherOutcome, Outcome).

% Section 29, applying section 12(1), (4): record a candidate only when an applicable defeat exists.
section29_rule_defeated(Person, Section, Rule) :-
    section29_rule_defeats(Person, Section, Rule, _HigherRule).

% Section 29, applying section 12(1), (4): accept an outcome only after rejecting defeated rules.
section29_accepted_outcome(Person, Section, Outcome) :-
    section29_rule_candidate(Person, Section, Outcome, Rule),
    not section29_rule_defeated(Person, Section, Rule).
