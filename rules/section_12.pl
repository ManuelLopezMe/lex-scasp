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

% Section 12(4): wartime withholding has priority over ordinary registration of an otherwise valid declaration.
section12_priority(s12_wartime_withholding, 20).

% Section 12(1): ordinary registration has lower priority than the wartime withholding power.
section12_priority(s12_ordinary_registration, 10).

% Sections 12(1), 12(4): numeric priority records that wartime withholding may defeat ordinary registration.
section12_higher_priority(HigherRule, LowerRule) :-
    section12_priority(HigherRule, HigherRank),
    section12_priority(LowerRule, LowerRank),
    HigherRank > LowerRank.

% Section 12(4): wartime withholding applies only when the declaration is made during the specified war and the Secretary of State withholds it.
section12_wartime_withholding_applies(Person) :-
    fact(Person, section12_made_during_qualifying_war, true),
    fact(Person, section12_secretary_withholds_registration, true).

% Section 12(4): outside the specified wartime circumstance, the Secretary of State has no subsection (4) withholding basis.
section12_registration_not_withheld(Person) :-
    fact(Person, section12_made_during_qualifying_war, false),
    section12_higher_priority(s12_wartime_withholding, s12_ordinary_registration).

% Section 12(4): during the specified wartime circumstance, an express non-withholding determination permits registration.
section12_registration_not_withheld(Person) :-
    fact(Person, section12_made_during_qualifying_war, true),
    fact(Person, section12_secretary_withholds_registration, false),
    section12_higher_priority(s12_wartime_withholding, s12_ordinary_registration).

% Section 12(1), (3)-(4): registration requires a valid declaration, nationality safeguard, and no subsection (4) withholding.
section12_declaration_registered(Person) :-
    section12_declaration_requirements(Person),
    section12_other_nationality_safeguard(Person),
    section12_registration_not_withheld(Person).

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
