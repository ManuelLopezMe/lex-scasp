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

% Section 29, applying Section 12(4): wartime withholding has priority over ordinary BOC declaration registration.
section29_priority(s29_wartime_withholding, 20).

% Section 29, applying Section 12(1): ordinary BOC declaration registration has lower priority than wartime withholding.
section29_priority(s29_ordinary_registration, 10).

% Section 29, applying Sections 12(1), 12(4): numeric priority records that wartime withholding may defeat ordinary registration.
section29_higher_priority(HigherRule, LowerRule) :-
    section29_priority(HigherRule, HigherRank),
    section29_priority(LowerRule, LowerRank),
    HigherRank > LowerRank.

% Section 29, applying Section 12(4): wartime withholding applies when the declaration is made during the specified war and the Secretary of State withholds registration.
section29_wartime_withholding_applies(Person) :-
    fact(Person, section29_made_during_qualifying_war, true),
    fact(Person, section29_secretary_withholds_registration, true).

% Section 29, applying Section 12(4): outside the specified wartime circumstance, subsection (4) supplies no withholding basis.
section29_registration_not_withheld(Person) :-
    fact(Person, section29_made_during_qualifying_war, false),
    section29_higher_priority(s29_wartime_withholding, s29_ordinary_registration).

% Section 29, applying Section 12(4): during the specified wartime circumstance, an express non-withholding determination permits registration.
section29_registration_not_withheld(Person) :-
    fact(Person, section29_made_during_qualifying_war, true),
    fact(Person, section29_secretary_withholds_registration, false),
    section29_higher_priority(s29_wartime_withholding, s29_ordinary_registration).

% Section 29, applying Sections 12(1), 12(3)-(4): a BOC declaration is registered only with the nationality safeguard and no wartime withholding.
section29_declaration_registered(Person) :-
    section29_declaration_requirements(Person),
    section29_other_nationality_safeguard(Person),
    section29_registration_not_withheld(Person).

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
