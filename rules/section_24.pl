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

% Section 24, applying section 12(4): wartime withholding has priority over ordinary BDT-citizen declaration registration.
section24_priority(s24_wartime_withholding, 20).

% Section 24, applying section 12(1): ordinary BDT-citizen declaration registration has lower priority than wartime withholding.
section24_priority(s24_ordinary_registration, 10).

% Section 24, applying sections 12(1), 12(4): numeric priority records that wartime withholding may defeat ordinary registration.
section24_higher_priority(HigherRule, LowerRule) :-
    section24_priority(HigherRule, HigherRank),
    section24_priority(LowerRule, LowerRank),
    HigherRank > LowerRank.

% Section 24, applying section 12(4): wartime withholding applies only when the declaration is made during the specified war and the Secretary of State withholds registration.
section24_wartime_withholding_applies(Person) :-
    fact(Person, section24_made_during_qualifying_war, true),
    fact(Person, section24_secretary_withholds_registration, true).

% Section 24, applying section 12(4): outside the specified wartime circumstance, subsection (4) supplies no withholding basis.
section24_registration_not_withheld(Person) :-
    fact(Person, section24_made_during_qualifying_war, false),
    section24_higher_priority(s24_wartime_withholding, s24_ordinary_registration).

% Section 24, applying section 12(4): during the specified wartime circumstance, an express non-withholding determination permits registration.
section24_registration_not_withheld(Person) :-
    fact(Person, section24_made_during_qualifying_war, true),
    fact(Person, section24_secretary_withholds_registration, false),
    section24_higher_priority(s24_wartime_withholding, s24_ordinary_registration).

% Section 24, applying section 12(1), (3)-(4): a BDT-citizen declaration is registered only with the nationality safeguard and no wartime withholding.
section24_declaration_registered(Person) :-
    section24_declaration_requirements(Person),
    section24_other_nationality_safeguard(Person),
    section24_registration_not_withheld(Person).

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
