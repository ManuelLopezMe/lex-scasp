:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

% Section 12(5): full age includes a person who has been married.
section12_full_age_requirement(Person) :-
    fact(Person, full_age, true).

% Section 12(5): a person who has been married is deemed to meet the age requirement.
section12_full_age_requirement(Person) :-
    fact(Person, has_been_married, true).

% Section 12(1): a valid declaration requires British citizenship, full capacity, statutory age, prescribed form, and declaration.
section12_declaration_requirements(Person) :-
    fact(Person, british_citizen, true),
    section12_full_age_requirement(Person),
    fact(Person, full_capacity, true),
    fact(Person, section12_declaration_made_in_prescribed_manner, true).

% Section 12(3): the Secretary of State must be satisfied that another nationality will be held or acquired after registration.
section12_other_nationality_safeguard(Person) :-
    fact(Person, section12_secretary_satisfied_other_nationality_will_be_held_or_acquired, true).

% Section 12(1), (3): an otherwise valid declaration supplies a registration candidate even if wartime withholding also applies.
section12_rule_candidate(Person, section12, declaration_registered, s12_ordinary_registration) :-
    section12_declaration_requirements(Person),
    section12_other_nationality_safeguard(Person).

% Section 12(4): wartime withholding supplies an opposing candidate when the Secretary of State exercises that power.
section12_rule_candidate(Person, section12, declaration_withheld, s12_wartime_withholding) :-
    fact(Person, section12_made_during_qualifying_war, true),
    fact(Person, section12_secretary_withholds_registration, true).

% Section 12(4): wartime withholding has priority over the otherwise valid ordinary registration candidate.
section12_rule_priority(section12, s12_wartime_withholding, 20).

% Section 12(1): ordinary declaration registration has lower priority than wartime withholding.
section12_rule_priority(section12, s12_ordinary_registration, 10).

% Section 12(1), (4): a declaration cannot be both registered and withheld.
section12_rule_conflict(section12, declaration_registered, declaration_withheld).

% Section 12(4): expose the applicable wartime candidate for conflict explanations and tests.
section12_wartime_withholding_applies(Person) :-
    section12_rule_candidate(Person, section12, declaration_withheld, s12_wartime_withholding).

% Section 12(1), (3)-(4): accept registration only when no higher-priority withholding candidate defeats it.
section12_declaration_registered(Person) :-
    section12_accepted_outcome(Person, section12, declaration_registered).

% Section 12(4): expose withholding only when it defeats a conflicting registration candidate.
section12_declaration_withheld(Person) :-
    section12_accepted_outcome(Person, section12, declaration_withheld).

% Section 12(1), (4): report whether ordinary registration survives priority resolution.
section12_registration_not_withheld(Person) :-
    section12_declaration_registered(Person).

% Section 12(2): a registered declaration causes cessation unless the six-month nationality safeguard restores status.
section12_ceases_to_be_british_citizen(Person) :-
    section12_declaration_registered(Person),
    fact(Person, section12_other_nationality_held_at_registration, true).

% Section 12(2)-(3): acquisition of another nationality within six months makes cessation effective.
section12_ceases_to_be_british_citizen(Person) :-
    section12_declaration_registered(Person),
    fact(Person, section12_acquired_other_nationality_within_six_months, true).

% Section 12(3): status is retained where no other nationality was held at registration and none was acquired within six months.
section12_remains_british_citizen(Person) :-
    section12_declaration_registered(Person),
    fact(Person, section12_other_nationality_held_at_registration, false),
    fact(Person, section12_acquired_other_nationality_within_six_months, false).

% Section 12(1), (4): the applicable wartime withholding candidate defeats ordinary registration.
section12_rule_defeats(Person, Section, LowerRule, HigherRule) :-
    section12_rule_candidate(Person, Section, LowerOutcome, LowerRule),
    section12_rule_candidate(Person, Section, HigherOutcome, HigherRule),
    section12_rule_conflicts(Section, LowerOutcome, HigherOutcome),
    section12_rule_priority(Section, LowerRule, LowerRank),
    section12_rule_priority(Section, HigherRule, HigherRank),
    HigherRank > LowerRank.

% Section 12(1), (4): conflicts apply in either candidate ordering.
section12_rule_conflicts(Section, Outcome, OtherOutcome) :-
    section12_rule_conflict(Section, Outcome, OtherOutcome).
section12_rule_conflicts(Section, Outcome, OtherOutcome) :-
    section12_rule_conflict(Section, OtherOutcome, Outcome).

% Section 12(1), (4): record a registration candidate only when an applicable defeat exists.
section12_rule_defeated(Person, Section, Rule) :-
    section12_rule_defeats(Person, Section, Rule, _HigherRule).

% Section 12(1), (4): accept a declaration outcome only after rejecting defeated rules.
section12_accepted_outcome(Person, Section, Outcome) :-
    section12_rule_candidate(Person, Section, Outcome, Rule),
    not section12_rule_defeated(Person, Section, Rule).
