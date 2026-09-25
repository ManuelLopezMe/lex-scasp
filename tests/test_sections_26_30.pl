:- use_module(library(plunit)).
:- use_module(library(scasp)).
:- use_module('../facts/rdf_facts.pl').
:- ensure_loaded('../rules/section_9.pl').
:- ensure_loaded('../rules/section_26.pl').
:- ensure_loaded('../rules/section_27.pl').
:- ensure_loaded('../rules/section_28.pl').
:- ensure_loaded('../rules/section_29.pl').
:- ensure_loaded('../rules/section_30.pl').

:- begin_tests(british_nationality_sections_26_30).

% Each test uses temporary fact/3 inputs to isolate one hypothetical.
with_facts(Person, Facts, Goal) :-
    setup_call_cleanup(
        maplist(assert_person_fact(Person), Facts),
        call(Goal),
        retractall(bna_rdf_facts:fact(Person, _, _))).

assert_person_fact(Person, Property-Value) :-
    assertz(bna_rdf_facts:fact(Person, Property, Value)).

proves(Goal) :-
    once(scasp(Goal, [])).

test(section_26_cukc_without_either_other_citizenship_becomes_boc) :-
    with_facts(s26_boc,
        [ cukc_immediately_before_commencement-true,
          becomes_british_citizen_at_commencement-false,
          becomes_bdt_citizen_at_commencement-false
        ],
        proves(section26_becomes_boc(s26_boc))).

test(section_26_british_citizen_at_commencement_excludes_boc, [fail]) :-
    with_facts(s26_british,
        [ cukc_immediately_before_commencement-true,
          becomes_british_citizen_at_commencement-true,
          becomes_bdt_citizen_at_commencement-false
        ],
        proves(section26_becomes_boc(s26_british))).

test(section_26_bdt_citizen_at_commencement_excludes_boc, [fail]) :-
    with_facts(s26_bdt,
        [ cukc_immediately_before_commencement-true,
          becomes_british_citizen_at_commencement-false,
          becomes_bdt_citizen_at_commencement-true
        ],
        proves(section26_becomes_boc(s26_bdt))).

test(section_27_discretionary_minor_registration) :-
    with_facts(s27_minor,
        [ section27_application_while_minor-true,
          secretary_of_state_approves_registration-true
        ],
        proves(section27_may_register_minor(s27_minor))).

test(section_27_minor_registration_requires_discretion, [fail]) :-
    with_facts(s27_no_decision,
        [ section27_application_while_minor-true,
          secretary_of_state_approves_registration-false
        ],
        proves(section27_may_register_minor(s27_no_decision))).

test(section_27_legacy_registration_with_adapted_section9_and_section26_tests) :-
    with_facts(s27_legacy,
        [ section27_born_in_foreign_country-true,
          section27_months_after_commencement_at_birth-60,
          section27_months_after_birth_at_application-12,
          registration_application-true,
          section27_father_section9_subsection_2_a_requirements_met-true,
          section27_father_adapted_section9_subsection_2_b_i_requirements_met-true,
          section27_would_become_boc_under_section26_in_precommencement_birth_counterfactual-true
        ],
        proves(section27_entitled_to_registration(s27_legacy))).

test(section_27_section9_adapted_father_test_but_for_death) :-
    with_facts(s27_father_death,
        [ section27_born_in_foreign_country-true,
          section27_months_after_commencement_at_birth-24,
          section27_months_after_birth_at_application-10,
          registration_application-true,
          section27_father_section9_subsection_2_a_requirements_met-true,
          section27_father_adapted_section9_subsection_2_b_ii_counterfactual_met-true,
          section27_would_become_boc_under_section26_in_precommencement_birth_counterfactual-true
        ],
        proves(section27_entitled_to_registration(s27_father_death))).

test(section_27_legacy_route_requires_adapted_section9_status_test, [fail]) :-
    with_facts(s27_no_adapted_s9,
        [ section27_born_in_foreign_country-true,
          section27_months_after_commencement_at_birth-12,
          section27_months_after_birth_at_application-6,
          registration_application-true,
          section27_father_section9_subsection_2_a_requirements_met-true,
          section27_father_adapted_section9_subsection_2_b_i_requirements_met-false,
          section27_father_adapted_section9_subsection_2_b_ii_counterfactual_met-false,
          section27_would_become_boc_under_section26_in_precommencement_birth_counterfactual-true
        ],
        proves(section27_entitled_to_registration(s27_no_adapted_s9))).

test(section_27_birth_after_five_year_window_fails, [fail]) :-
    with_facts(s27_late_birth,
        [ section27_born_in_foreign_country-true,
          section27_months_after_commencement_at_birth-61,
          section27_months_after_birth_at_application-12,
          registration_application-true,
          section27_father_section9_subsection_2_a_requirements_met-true,
          section27_father_adapted_section9_subsection_2_b_i_requirements_met-true,
          section27_would_become_boc_under_section26_in_precommencement_birth_counterfactual-true
        ],
        proves(section27_entitled_to_registration(s27_late_birth))).

test(section_27_application_over_twelve_months_fails, [fail]) :-
    with_facts(s27_late_application,
        [ section27_born_in_foreign_country-true,
          section27_months_after_commencement_at_birth-1,
          section27_months_after_birth_at_application-13,
          registration_application-true,
          section27_father_section9_subsection_2_a_requirements_met-true,
          section27_father_adapted_section9_subsection_2_b_i_requirements_met-true,
          section27_would_become_boc_under_section26_in_precommencement_birth_counterfactual-true
        ],
        proves(section27_entitled_to_registration(s27_late_application))).

test(section_28_mandatory_route_with_all_conditions) :-
    with_facts(s28_mandatory,
        [ registration_application-true,
          section28_months_after_commencement_at_application-60,
          section28_was_wife_of_cukc_immediately_before_commencement-true,
          section28_would_be_entitled_under_1948_act_section_6_2-true,
          section28_husband_became_boc_at_commencement-true,
          section28_husband_did_not_cease_boc_by_renunciation_before_application-true,
          section28_remained_married_to_husband_throughout_period-true
        ],
        proves(section28_entitled_to_registration(s28_mandatory))).

test(section_28_mandatory_route_fails_after_husband_renunciation, [fail]) :-
    with_facts(s28_renounced,
        [ registration_application-true,
          section28_months_after_commencement_at_application-24,
          section28_was_wife_of_cukc_immediately_before_commencement-true,
          section28_would_be_entitled_under_1948_act_section_6_2-true,
          section28_husband_became_boc_at_commencement-true,
          section28_husband_did_not_cease_boc_by_renunciation_before_application-false,
          section28_remained_married_to_husband_throughout_period-true
        ],
        proves(section28_entitled_to_registration(s28_renounced))).

test(section_28_discretionary_former_marriage_route_but_for_death) :-
    with_facts(s28_death,
        [ registration_application-true,
          section28_months_after_commencement_at_application-48,
          section28_would_be_entitled_under_1948_act_section_6_2-true,
          section28_no_longer_married_to_historical_husband_on_application-true,
          section28_husband_would_become_boc_at_commencement_but_for_death-true,
          secretary_of_state_approves_registration-true
        ],
        proves(section28_may_register_former_marriage(s28_death))).

test(section_28_discretionary_current_marriage_after_renunciation) :-
    with_facts(s28_current_renounced,
        [ registration_application-true,
          section28_months_after_commencement_at_application-12,
          section28_married_to_husband_on_application_date-true,
          section28_would_be_entitled_under_1948_act_section_6_2_through_current_husband-true,
          section28_current_husband_became_boc_at_commencement-true,
          section28_current_husband_ceased_boc_by_renunciation-true,
          secretary_of_state_approves_registration-true
        ],
        proves(section28_may_register_current_marriage(s28_current_renounced))).

test(section_28_current_marriage_route_allows_husband_cukc_renunciation_counterfactual) :-
    with_facts(s28_cukc_renunciation,
        [ registration_application-true,
          section28_months_after_commencement_at_application-12,
          section28_married_to_husband_on_application_date-true,
          section28_would_be_entitled_under_1948_act_section_6_2_through_current_husband-true,
          section28_current_husband_would_become_boc_but_for_cukc_renunciation-true,
          secretary_of_state_approves_registration-true
        ],
        proves(section28_may_register_current_marriage(s28_cukc_renunciation))).

test(section_28_marriage_application_after_five_year_window_fails, [fail]) :-
    with_facts(s28_late,
        [ registration_application-true,
          section28_months_after_commencement_at_application-61,
          section28_married_to_husband_on_application_date-true,
          section28_would_be_entitled_under_1948_act_section_6_2_through_current_husband-true,
          section28_current_husband_would_become_boc_but_for_cukc_renunciation-true,
          secretary_of_state_approves_registration-true
        ],
        proves(section28_may_register_current_marriage(s28_late))).

test(section_29_boc_declaration_registers_and_ceases_after_other_nationality) :-
    with_facts(s29_ceases,
        [ british_overseas_citizen-true,
          full_age-true,
          full_capacity-true,
          section29_declaration_made_in_prescribed_manner-true,
          section29_secretary_satisfied_other_nationality_will_be_held_or_acquired-true,
          section29_made_during_qualifying_war-false,
          section29_other_nationality_held_at_registration-true,
          section29_acquired_other_nationality_within_six_months-false
        ],
        proves(section29_ceases_to_be_boc(s29_ceases))).

test(section_29_boc_six_month_safeguard_retains_status) :-
    with_facts(s29_retains,
        [ british_overseas_citizen-true,
          has_been_married-true,
          full_capacity-true,
          section29_declaration_made_in_prescribed_manner-true,
          section29_secretary_satisfied_other_nationality_will_be_held_or_acquired-true,
          section29_made_during_qualifying_war-false,
          section29_other_nationality_held_at_registration-false,
          section29_acquired_other_nationality_within_six_months-false
        ],
        proves(section29_remains_boc(s29_retains))).

test(section_29_wartime_withholding_blocks_registration) :-
    with_facts(s29_wartime,
        [ british_overseas_citizen-true,
          full_age-true,
          full_capacity-true,
          section29_declaration_made_in_prescribed_manner-true,
          section29_secretary_satisfied_other_nationality_will_be_held_or_acquired-true,
          section29_made_during_qualifying_war-true,
          section29_secretary_withholds_registration-true
        ],
        proves(section29_wartime_withholding_applies(s29_wartime))).

test(section_29_british_citizenship_does_not_substitute_for_boc_status, [fail]) :-
    with_facts(s29_no_boc,
        [ british_citizen-true,
          full_age-true,
          full_capacity-true,
          section29_declaration_made_in_prescribed_manner-true,
          section29_secretary_satisfied_other_nationality_will_be_held_or_acquired-true,
          section29_made_during_qualifying_war-false
        ],
        proves(section29_declaration_registered(s29_no_boc))).

test(section_29_british_renunciation_facts_do_not_supply_boc_safeguards, [fail]) :-
    with_facts(s29_no_safeguard,
        [ british_overseas_citizen-true,
          full_age-true,
          full_capacity-true,
          section29_declaration_made_in_prescribed_manner-true,
          section12_secretary_satisfied_other_nationality_will_be_held_or_acquired-true,
          section12_made_during_qualifying_war-false
        ],
        proves(section29_declaration_registered(s29_no_safeguard))).

test(section_29_other_nationality_acquired_within_six_months_causes_cessation) :-
    with_facts(s29_acquired,
        [ british_overseas_citizen-true,
          full_age-true,
          full_capacity-true,
          section29_declaration_made_in_prescribed_manner-true,
          section29_secretary_satisfied_other_nationality_will_be_held_or_acquired-true,
          section29_made_during_qualifying_war-false,
          section29_other_nationality_held_at_registration-false,
          section29_acquired_other_nationality_within_six_months-true
        ],
        proves(section29_ceases_to_be_boc(s29_acquired))).

test(section_30_section_13_or_16_1948_act_subject_continues) :-
    with_facts(section_thirty_1948_subject,
        [ british_subject_without_citizenship_under_1948_act_section_13_or_16_immediately_before_commencement-true
        ],
        proves(section30_continues_as_british_subject(section_thirty_1948_subject))).

test(section_30_1965_act_alien_wife_subject_continues) :-
    with_facts(section_thirty_1965_subject,
        [ british_subject_under_1965_act_section_1_immediately_before_commencement-true
        ],
        proves(section30_continues_as_british_subject(section_thirty_1965_subject))).

test(section_30_unlisted_historic_category_does_not_continue, [fail]) :-
    with_facts(section_thirty_other_subject,
        [ british_subject_without_citizenship_under_other_provision_immediately_before_commencement-true
        ],
        proves(section30_continues_as_british_subject(section_thirty_other_subject))).

:- end_tests(british_nationality_sections_26_30).
