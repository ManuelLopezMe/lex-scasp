:- use_module(library(plunit)).
:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').
:- ensure_loaded('../rules/section_15.pl').
:- ensure_loaded('../rules/section_16.pl').
:- ensure_loaded('../rules/section_17.pl').
:- ensure_loaded('../rules/section_18.pl').
:- ensure_loaded('../rules/section_19.pl').
:- ensure_loaded('../rules/section_20.pl').
:- ensure_loaded('../rules/section_21.pl').
:- ensure_loaded('../rules/section_22.pl').
:- ensure_loaded('../rules/section_23.pl').
:- ensure_loaded('../rules/section_24.pl').
:- ensure_loaded('../rules/section_25.pl').

:- begin_tests(british_nationality_sections_15_25).

% Each test uses temporary fact/3 inputs to isolate one hypothetical.
with_facts(Person, Facts, Goal) :-
    setup_call_cleanup(
        maplist(assert_person_fact(Person), Facts),
        call(Goal),
        retractall(bna_facts:fact(Person, _, _))).

assert_person_fact(Person, Property-Value) :-
    assertz(bna_facts:fact(Person, Property, Value)).

proves(Goal) :-
    once(scasp(Goal, [])).

test(section_15_birth_in_territory_to_bdt_parent) :-
    with_facts(s15_birth,
        [ born_in_dependent_territory-true,
          after_commencement-true,
          section15_parent_bdt_citizen_at_birth-true
        ],
        proves(section15_acquires_bdt_citizenship(s15_birth))).

test(section_15_abandoned_infant_presumption) :-
    with_facts(s15_abandoned,
        [ after_commencement-true,
          section15_newborn_found_abandoned_in_dependent_territory-true,
          section15_parentage_contrary_shown-false
        ],
        proves(section15_acquires_bdt_citizenship(s15_abandoned))).

test(section_15_contrary_evidence_defeats_abandonment_presumption, [fail]) :-
    with_facts(s15_contrary,
        [ after_commencement-true,
          section15_newborn_found_abandoned_in_dependent_territory-true,
          section15_parentage_contrary_shown-true
        ],
        proves(section15_acquires_bdt_citizenship(s15_contrary))).

test(section_15_contrary_evidence_is_explicit_higher_priority_rule) :-
    with_facts(s15_contrary_priority,
        [ after_commencement-true,
          section15_newborn_found_abandoned_in_dependent_territory-true,
          section15_parentage_contrary_shown-true
        ],
        proves(section15_abandonment_presumption_defeated(s15_contrary_priority))).

test(section_15_contrary_evidence_defeats_abandonment_candidate) :-
    with_facts(s15_abandonment_conflict,
        [ after_commencement-true,
          section15_newborn_found_abandoned_in_dependent_territory-true,
          section15_parentage_contrary_shown-true
        ],
        proves((section15_rule_candidate(
              s15_abandonment_conflict, section15_abandonment,
              presumed_qualifying_parent, s15_abandonment_presumption),
          section15_rule_candidate(
              s15_abandonment_conflict, section15_abandonment,
              presumption_rebutted, s15_contrary_evidence),
          section15_rule_defeats(
              s15_abandonment_conflict, section15_abandonment,
              s15_abandonment_presumption, s15_contrary_evidence),
          section15_abandonment_presumption_defeated(s15_abandonment_conflict)))).

test(section_15_minor_registration_after_parent_becomes_settled) :-
    with_facts(s15_minor,
        [ born_in_dependent_territory-true,
          after_commencement-true,
          section15_not_citizen_under_subsections_1_2-true,
          section15_parent_becomes_settled_in_dependent_territory_while_minor-true,
          section15_application_while_minor-true
        ],
        proves(section15_entitled_to_registration(s15_minor))).

test(section_15_first_ten_years_absence_at_90_day_limit) :-
    with_facts(s15_ten_year_boundary,
        [ born_in_dependent_territory-true,
          after_commencement-true,
          section15_not_citizen_under_subsections_1_2-true,
          section15_application_after_tenth_birthday-true,
          section15_each_first_ten_years_absence_at_most_90_days-true
        ],
        proves(section15_entitled_to_registration(s15_ten_year_boundary))).

test(section_15_special_circumstances_relieve_excess_absence) :-
    with_facts(s15_relief,
        [ born_in_dependent_territory-true,
          after_commencement-true,
          section15_not_citizen_under_subsections_1_2-true,
          section15_application_after_tenth_birthday-true,
          section15_each_first_ten_years_absence_at_most_90_days-false,
          section15_secretary_approves_special_absence_relief-true
        ],
        proves(section15_entitled_to_registration(s15_relief))).

test(section_15_adoption_order_cessation_does_not_remove_status) :-
    with_facts(s15_adoption,
        [ section15_became_bdt_citizen_under_subsection_5-true,
          section15_adoption_order_ceased_to_have_effect-true
        ],
        proves(section15_retains_bdt_citizenship_after_adoption_order_cessation(s15_adoption))).

test(section_15_adoption_by_bdt_citizen_confers_citizenship) :-
    with_facts(s15_adoption_acquisition,
        [ section15_adoptee_not_bdt_citizen_before_order-true,
          section15_adoption_order_made_by_dependent_territory_court-true,
          section15_adopter_bdt_citizen_on_order_date-true
        ],
        proves(section15_acquires_bdt_citizenship(s15_adoption_acquisition))).

test(section_16_overseas_birth_to_parent_otherwise_than_by_descent) :-
    with_facts(s16_parent,
        [ born_outside_dependent_territories-true,
          after_commencement-true,
          section16_parent_bdt_citizen_otherwise_than_by_descent_at_birth-true
        ],
        proves(section16_acquires_bdt_citizenship(s16_parent))).

test(section_16_designated_service_requires_designation_and_local_recruitment, [fail]) :-
    with_facts(s16_service_not_designated,
        [ born_outside_dependent_territories-true,
          after_commencement-true,
          section16_parent_bdt_citizen_at_birth-true,
          section16_parent_serving_outside_dependent_territories_at_birth-true,
          section16_parent_service_type-designated_service,
          section16_parent_recruited_in_dependent_territory-true
        ],
        proves(section16_acquires_bdt_citizenship(s16_service_not_designated))).

test(section_16_designated_service_route) :-
    with_facts(s16_service,
        [ born_outside_dependent_territories-true,
          after_commencement-true,
          section16_parent_bdt_citizen_at_birth-true,
          section16_parent_serving_outside_dependent_territories_at_birth-true,
          section16_parent_service_type-designated_service,
          section16_service_description_designated_by_order-true,
          section16_parent_recruited_in_dependent_territory-true
        ],
        proves(section16_acquires_bdt_citizenship(s16_service))).

test(section_17_discretionary_minor_registration) :-
    with_facts(s17_minor,
        [ section17_application_while_minor-true,
          secretary_of_state_approves_registration-true
        ],
        proves(section17_may_register_minor(s17_minor))).

test(section_17_birth_registration_nonstateless_270_day_boundary) :-
    with_facts(s17_birth_boundary,
        [ born_outside_dependent_territories-true,
          section17_application_within_twelve_months_of_birth-true,
          section17_born_stateless-false,
          section17_parent_bdt_citizen_by_descent_at_applicant_birth-true,
          section17_grandparent_bdt_otherwise_than_by_descent_at_parent_birth-true,
          section17_parent_three_year_residence_before_birth_met-true
        ],
        proves(section17_entitled_to_birth_registration(s17_birth_boundary))).

test(section_17_nonstateless_parent_over_270_day_limit_fails, [fail]) :-
    with_facts(s17_absence_exceeded,
        [ born_outside_dependent_territories-true,
          section17_application_within_twelve_months_of_birth-true,
          section17_born_stateless-false,
          section17_parent_bdt_citizen_by_descent_at_applicant_birth-true,
          section17_grandparent_bdt_otherwise_than_by_descent_at_parent_birth-true,
          section17_parent_three_year_residence_before_birth_met-false
        ],
        proves(section17_entitled_to_birth_registration(s17_absence_exceeded))).

test(section_17_stateless_birth_registration_does_not_require_residence) :-
    with_facts(s17_stateless,
        [ born_outside_dependent_territories-true,
          section17_application_within_twelve_months_of_birth-true,
          section17_born_stateless-true,
          section17_parent_bdt_citizen_by_descent_at_applicant_birth-true,
          section17_grandparent_became_bdt_otherwise_than_by_descent_at_commencement-true
        ],
        proves(section17_entitled_to_birth_registration(s17_stateless))).

test(section_17_six_year_extension_requires_special_circumstances) :-
    with_facts(s17_extension,
        [ born_outside_dependent_territories-true,
          section17_application_within_six_years_of_birth-true,
          section17_secretary_approves_six_year_extension-true,
          section17_born_stateless-true,
          section17_parent_bdt_citizen_by_descent_at_applicant_birth-true,
          section17_grandparent_would_become_bdt_otherwise_than_by_descent_but_for_death-true
        ],
        proves(section17_entitled_to_birth_registration(s17_extension))).

test(section_17_minor_registration_shared_residence_and_consent) :-
    with_facts(s17_minor_route,
        [ born_outside_dependent_territories-true,
          section17_application_while_minor-true,
          section17_parent_bdt_citizen_by_descent_at_applicant_birth-true,
          section17_subsection_5_family_residence_and_consent_requirements_met-true
        ],
        proves(section17_entitled_to_minor_registration(s17_minor_route))).

test(section_18_general_naturalisation_uses_schedule_1_input) :-
    with_facts(s18_general,
        [ naturalisation_application-true,
          full_age-true,
          full_capacity-true,
          section18_relevant_dependent_territory_specified-true,
          section18_schedule1_general_requirements_satisfied-true,
          secretary_of_state_approves_naturalisation-true
        ],
        proves(section18_may_grant_naturalisation(s18_general))).

test(section_18_spouse_naturalisation_has_separate_schedule_input) :-
    with_facts(s18_spouse,
        [ naturalisation_application-true,
          full_age-true,
          full_capacity-true,
          married_to_bdt_citizen_on_application_date-true,
          section18_relevant_dependent_territory_specified-true,
          section18_schedule1_spouse_requirements_satisfied-true,
          secretary_of_state_approves_naturalisation-true
        ],
        proves(section18_may_grant_naturalisation(s18_spouse))).

test(section_18_missing_relevant_territory_or_schedule_determination_fails, [fail]) :-
    with_facts(s18_incomplete,
        [ naturalisation_application-true,
          full_age-true,
          full_capacity-true,
          secretary_of_state_approves_naturalisation-true
        ],
        proves(section18_may_grant_naturalisation(s18_incomplete))).

test(section_19_five_year_residence_counterfactual) :-
    with_facts(s19_boundary,
        [ registration_application-true,
          section19_minor_at_commencement-false,
          section19_immigration_act_schedule_1_paragraph_2_counterfactual_entitlement-true,
          section19_application_within_five_years_after_commencement-true
        ],
        proves(section19_entitled_to_registration(s19_boundary))).

test(section_19_eight_year_extension) :-
    with_facts(s19_extension,
        [ registration_application-true,
          section19_minor_at_commencement-false,
          section19_immigration_act_schedule_1_paragraph_2_counterfactual_entitlement-true,
          section19_application_within_eight_years_after_commencement-true,
          section19_secretary_approves_eight_year_extension-true
        ],
        proves(section19_entitled_to_registration(s19_extension))).

test(section_19_minor_period_runs_from_full_age) :-
    with_facts(s19_minor_period,
        [ registration_application-true,
          section19_minor_at_commencement-true,
          section19_immigration_act_schedule_1_paragraph_2_counterfactual_entitlement-true,
          section19_application_within_five_years_after_full_age-true
        ],
        proves(section19_entitled_to_registration(s19_minor_period))).

test(section_19_minor_cannot_use_general_commencement_window, [fail]) :-
    with_facts(s19_minor_wrong_window,
        [ registration_application-true,
          section19_minor_at_commencement-true,
          section19_immigration_act_schedule_1_paragraph_2_counterfactual_entitlement-true,
          section19_application_within_five_years_after_commencement-true,
          section19_application_within_five_years_after_full_age-false
        ],
        proves(section19_entitled_to_registration(s19_minor_wrong_window))).

test(section_19_counterfactual_entitlement_not_assumed, [fail]) :-
    with_facts(s19_missing_counterfactual,
        [ registration_application-true,
          section19_application_within_five_years_after_commencement-true
        ],
        proves(section19_entitled_to_registration(s19_missing_counterfactual))).

test(section_20_mandatory_marriage_registration) :-
    with_facts(s20_entitlement,
        [ section20_applicant_was_wife_immediately_before_commencement-true,
          registration_application-true,
          section20_application_within_five_years_after_commencement-true,
          section20_1948_act_section_6_2_marriage_entitlement-true,
          section20_husband_became_bdt_citizen_at_commencement-true,
          section20_husband_did_not_renounce_bdt_citizenship_before_application-true,
          section20_marriage_continued_through_application-true
        ],
        proves(section20_entitled_to_registration(s20_entitlement))).

test(section_20_discretionary_current_marriage_after_husbands_renunciation) :-
    with_facts(s20_discretion,
        [ registration_application-true,
          section20_application_within_five_years_after_commencement-true,
          section20_applicant_married_at_application-true,
          section20_1948_act_section_6_2_entitlement_by_current_husband-true,
          section20_husband_became_bdt_then_renounced_or_would_but_for_cukc_renunciation-true,
          secretary_of_state_approves_registration-true
        ],
        proves(section20_may_register(s20_discretion))).

test(section_20_application_after_five_years_fails, [fail]) :-
    with_facts(s20_late,
        [ section20_applicant_was_wife_immediately_before_commencement-true,
          registration_application-true,
          section20_application_within_five_years_after_commencement-false,
          section20_1948_act_section_6_2_marriage_entitlement-true,
          section20_husband_became_bdt_citizen_at_commencement-true,
          section20_husband_did_not_renounce_bdt_citizenship_before_application-true,
          section20_marriage_continued_through_application-true
        ],
        proves(section20_entitled_to_registration(s20_late))).

test(section_21_adapted_father_test_and_commencement_counterfactual) :-
    with_facts(s21_birth,
        [ section21_born_in_foreign_country-true,
          section21_birth_within_five_years_after_commencement-true,
          registration_application-true,
          section21_application_within_twelve_months_of_birth-true,
          section21_adapted_section9_father_requirements_met_for_bdt_citizenship-true,
          section21_would_become_bdt_under_section23_1_b_at_commencement-true
        ],
        proves(section21_entitled_to_registration(s21_birth))).

test(section_22_mandatory_connection_registration_once) :-
    with_facts(s22_connection,
        [ registration_application-true,
          section22_would_have_been_entitled_under_1964_act_for_territory_connection-true,
          section22_connection_qualification-birth_in_dependent_territory,
          section22_prior_subsection_1_registration-false
        ],
        proves(section22_entitled_to_registration(s22_connection))).

test(section_22_woman_may_qualify_through_spouses_connection) :-
    with_facts(s22_spouse_connection,
        [ registration_application-true,
          section22_woman-true,
          section22_would_have_been_entitled_under_1964_act_for_territory_connection-true,
          section22_spouse_has_appropriate_qualifying_connection-true,
          section22_prior_subsection_1_registration-false
        ],
        proves(section22_entitled_to_registration(s22_spouse_connection))).

test(section_22_prior_mandatory_registration_blocks_entitlement, [fail]) :-
    with_facts(s22_used_once,
        [ registration_application-true,
          section22_would_have_been_entitled_under_1964_act_for_territory_connection-true,
          section22_connection_qualification-cukc_registration_in_dependent_territory,
          section22_prior_subsection_1_registration-true
        ],
        proves(section22_entitled_to_registration(s22_used_once))).

test(section_22_discretionary_route_after_renunciation) :-
    with_facts(s22_discretion,
        [ registration_application-true,
          full_capacity-true,
          section22_ceased_to_be_cukc_by_renunciation_before_commencement-true,
          section22_connection_qualification-british_subject_by_dependent_territory_annexation,
          secretary_of_state_approves_registration-true
        ],
        proves(section22_may_register(s22_discretion))).

test(section_23_territorial_cukc_basis_at_commencement) :-
    with_facts(s23_territorial,
        [ section23_cukc_immediately_before_commencement-true,
          section23_cukc_acquired_by_birth_in_dependent_territory-true
        ],
        proves(section23_becomes_bdt_citizen_at_commencement(s23_territorial))).

test(section_23_parentage_route_includes_pre_1949_construction_input) :-
    with_facts(s23_parent,
        [ section23_cukc_immediately_before_commencement-true,
          section23_born_to_cukc_parent_at_material_time-true,
          section23_parent_cukc_territorial_origin_or_qualifying_parent-true
        ],
        proves(section23_becomes_bdt_citizen_at_commencement(s23_parent))).

test(section_23_minor_registration_parent_link) :-
    with_facts(s23_minor,
        [ section23_cukc_registered_under_1948_act_section_7_or_1964_stateless_act-true,
          section23_cukc_immediately_before_commencement-true,
          section23_registration_outside_dependent_territory-true,
          section23_applicable_parent_cukc_at_registration_or_would_but_for_death-true,
          section23_applicable_parent_becomes_bdt_at_commencement_or_would_but_for_death-true
        ],
        proves(section23_becomes_bdt_citizen_at_commencement(s23_minor))).

test(section_23_woman_qualifies_through_husbands_commencement_status) :-
    with_facts(s23_woman,
        [ section23_woman_cukc_immediately_before_commencement-true,
          section23_was_or_had_been_wife_of_qualifying_man-true,
          section23_husband_becomes_bdt_under_subsection_1_a_or_b_or_would_but_for_death-true
        ],
        proves(section23_becomes_bdt_citizen_at_commencement(s23_woman))).

test(section_23_section_12_6_historic_male_line_route) :-
    with_facts(s23_historic_line,
        [ section23_cukc_registered_under_1948_act_section_12_6-true,
          section23_cukc_immediately_before_commencement-true,
          section23_registration_outside_dependent_territory-true,
          section23_section_12_6_historical_descent_conditions_met-true,
          section23_relevant_person_born_or_naturalised_in_dependent_territory_or_annexed-true
        ],
        proves(section23_becomes_bdt_citizen_at_commencement(s23_historic_line))).

test(section_23_1964_resumption_uses_prescribed_connection) :-
    with_facts(s23_resumption,
        [ section23_cukc_registered_under_1964_act_section_1_resumption-true,
          section23_cukc_immediately_before_commencement-true,
          section23_registration_outside_dependent_territory-true,
          section23_connection_qualification-naturalisation_in_dependent_territory
        ],
        proves(section23_becomes_bdt_citizen_at_commencement(s23_resumption))).

test(section_23_missing_territorial_basis_does_not_confer_status, [fail]) :-
    with_facts(s23_no_basis,
        [ section23_cukc_immediately_before_commencement-true
        ],
        proves(section23_becomes_bdt_citizen_at_commencement(s23_no_basis))).

test(section_23_section_7_registration_requires_cukc_at_commencement, [fail]) :-
    with_facts(s23_lost_cukc,
        [ section23_cukc_registered_under_1948_act_section_7_or_1964_stateless_act-true,
          section23_registration_outside_dependent_territory-true,
          section23_applicable_parent_cukc_at_registration_or_would_but_for_death-true,
          section23_applicable_parent_becomes_bdt_at_commencement_or_would_but_for_death-true
        ],
        proves(section23_becomes_bdt_citizen_at_commencement(s23_lost_cukc))).

test(section_24_bdt_renunciation_uses_bdt_not_british_citizen_fact) :-
    with_facts(s24_bdt_declaration,
        [ bdt_citizen-true,
          full_age-true,
          full_capacity-true,
          section24_declaration_made_in_prescribed_manner-true,
          section24_secretary_satisfied_other_nationality_will_be_held_or_acquired-true,
          section24_made_during_qualifying_war-false,
          section24_other_nationality_held_at_registration-true
        ],
        proves(section24_ceases_to_be_bdt_citizen(s24_bdt_declaration))).

test(section_24_british_citizen_fact_alone_does_not_authorize_bdt_renunciation, [fail]) :-
    with_facts(s24_wrong_class,
        [ british_citizen-true,
          full_age-true,
          full_capacity-true,
          section24_declaration_made_in_prescribed_manner-true,
          section24_secretary_satisfied_other_nationality_will_be_held_or_acquired-true,
          section24_made_during_qualifying_war-false
        ],
        proves(section24_declaration_registered(s24_wrong_class))).

test(section_24_wartime_withholding_overrides_bdt_registration) :-
    with_facts(s24_wartime,
        [ bdt_citizen-true,
          full_age-true,
          full_capacity-true,
          section24_declaration_made_in_prescribed_manner-true,
          section24_secretary_satisfied_other_nationality_will_be_held_or_acquired-true,
          section24_made_during_qualifying_war-true,
          section24_secretary_withholds_registration-true
        ],
        proves(section24_wartime_withholding_applies(s24_wartime))).

test(section_24_wartime_withholding_blocks_bdt_registration, [fail]) :-
    with_facts(s24_wartime_blocks,
        [ bdt_citizen-true,
          full_age-true,
          full_capacity-true,
          section24_declaration_made_in_prescribed_manner-true,
          section24_secretary_satisfied_other_nationality_will_be_held_or_acquired-true,
          section24_made_during_qualifying_war-true,
          section24_secretary_withholds_registration-true
        ],
        proves(section24_declaration_registered(s24_wartime_blocks))).

test(section_24_wartime_withholding_defeats_bdt_registration_candidate) :-
    with_facts(s24_priority_conflict,
        [ bdt_citizen-true,
          full_age-true,
          full_capacity-true,
          section24_declaration_made_in_prescribed_manner-true,
          section24_secretary_satisfied_other_nationality_will_be_held_or_acquired-true,
          section24_made_during_qualifying_war-true,
          section24_secretary_withholds_registration-true
        ],
        proves((section24_rule_candidate(
              s24_priority_conflict, section24,
              declaration_registered, s24_ordinary_registration),
          section24_rule_candidate(
              s24_priority_conflict, section24,
              declaration_withheld, s24_wartime_withholding),
          section24_rule_defeats(
              s24_priority_conflict, section24,
              s24_ordinary_registration, s24_wartime_withholding),
          section24_accepted_outcome(
              s24_priority_conflict, section24, declaration_withheld)))).

test(section_24_bdt_resumption_requires_bdt_renunciation_facts) :-
    with_facts(s24_resume,
        [ section24_ceased_bdt_citizen_by_renunciation-true,
          full_capacity-true,
          registration_application-true,
          section24_renunciation_necessary_for_other_nationality-true,
          section24_prior_subsection_13_1_registration-false
        ],
        proves(section24_entitled_to_resumption_registration(s24_resume))).

test(section_24_british_resumption_facts_alone_do_not_qualify, [fail]) :-
    with_facts(s24_wrong_resumption_class,
        [ section13_ceased_british_citizen_by_renunciation-true,
          full_capacity-true,
          registration_application-true,
          section13_renunciation_necessary_for_other_nationality-true,
          section13_prior_subsection_1_registration-false
        ],
        proves(section24_entitled_to_resumption_registration(s24_wrong_resumption_class))).

test(section_25_section_16_1_a_citizenship_is_by_descent) :-
    with_facts(s25_section16,
        [ section25_citizenship_basis-section16_1_a_only,
          born_outside_dependent_territories-true,
          after_commencement-true
        ],
        proves(section25_by_descent(s25_section16))).

test(section_25_section_17_2_registration_is_by_descent) :-
    with_facts(s25_section17_2_case,
        [ section25_citizenship_basis-section17_2_registration
        ],
        proves(section25_by_descent(s25_section17_2_case))).

test(section_25_section_21_registration_is_by_descent) :-
    with_facts(s25_section21,
        [ section25_citizenship_basis-section21_registration
        ],
        proves(section25_by_descent(s25_section21))).

test(section_25_precommencement_section_5_cukc_descent_is_by_descent) :-
    with_facts(s25_section5,
        [ section25_citizenship_basis-section23_commencement,
          born_outside_dependent_territories-true,
          before_commencement-true,
          section25_cukc_by_1948_act_section_5_descent-true
        ],
        proves(section25_by_descent(s25_section5))).

test(section_25_historic_descent_route_without_service_exception) :-
    with_facts(s25_historic,
        [ section25_citizenship_basis-section23_1_b_only,
          born_outside_dependent_territories-true,
          before_commencement-true
        ],
        proves(section25_by_descent(s25_historic))).

test(section_25_service_exception_overrides_historic_descent) :-
    with_facts(s25_service,
        [ section25_citizenship_basis-section23_1_b_only,
          born_outside_dependent_territories-true,
          before_commencement-true,
          section25_father_serving_outside_dependent_territories_at_birth-true,
          section25_father_service_type-dependent_territory_crown,
          section25_father_recruited_in_dependent_territory-true
        ],
        proves(section25_not_by_descent(s25_service))).

test(section_25_service_exception_defeats_historic_descent_candidate) :-
    with_facts(s25_priority_conflict,
        [ section25_citizenship_basis-section23_1_b_only,
          born_outside_dependent_territories-true,
          before_commencement-true,
          section25_father_serving_outside_dependent_territories_at_birth-true,
          section25_father_service_type-dependent_territory_crown,
          section25_father_recruited_in_dependent_territory-true
        ],
        proves((section25_rule_candidate(
              s25_priority_conflict, section25, by_descent,
              s25_historical_descent),
          section25_rule_candidate(
              s25_priority_conflict, section25, not_by_descent,
              s25_service_exception),
          section25_rule_defeats(
              s25_priority_conflict, section25, s25_historical_descent,
              s25_service_exception),
          section25_not_by_descent(s25_priority_conflict)))).

test(section_25_designated_service_exception_requires_designation_input) :-
    with_facts(s25_designated,
        [ section25_citizenship_basis-section23_1_b_only,
          born_outside_dependent_territories-true,
          before_commencement-true,
          section25_father_serving_outside_dependent_territories_at_birth-true,
          section25_father_service_type-designated_service,
          section25_service_description_designated_under_section16_3-true,
          section25_father_recruited_in_dependent_territory-true
        ],
        proves(section25_not_by_descent(s25_designated))).

test(section_25_designated_service_requires_express_designation, [fail]) :-
    with_facts(s25_undesignated,
        [ section25_citizenship_basis-section23_1_b_only,
          born_outside_dependent_territories-true,
          before_commencement-true,
          section25_father_serving_outside_dependent_territories_at_birth-true,
          section25_father_service_type-designated_service,
          section25_father_recruited_in_dependent_territory-true
        ],
        proves(section25_not_by_descent(s25_undesignated))).

test(section_25_section_17_1_route_parent_citizenship_at_birth) :-
    with_facts(s25_section17,
        [ section25_citizenship_basis-section17_1_registration,
          section25_parent_bdt_citizen_at_birth-true
        ],
        proves(section25_by_descent(s25_section17))).

test(section_25_section_23_1_c_wife_is_by_descent_through_husband) :-
    with_facts(s25_wife_at_commencement,
        [ section25_citizenship_basis-section23_1_c_only,
          section25_woman_became_bdt_at_commencement_only_through_marriage-true,
          section25_husband_bdt_by_descent_under_1_b_or_d_or_would_but_for_death-true
        ],
        proves(section25_by_descent(s25_wife_at_commencement))).

test(section_25_section_20_marriage_registration_is_by_descent) :-
    with_facts(s25_section20,
        [ section25_citizenship_basis-section20_registration,
          born_outside_dependent_territories-true,
          before_commencement-true,
          section25_husband_bdt_by_descent_at_commencement_or_would_but_for_death_or_cukc_renunciation-true
        ],
        proves(section25_by_descent(s25_section20))).

test(section_25_section_22_renunciation_route_is_by_descent) :-
    with_facts(s25_section22,
        [ section25_citizenship_basis-section22_registration_after_renunciation,
          section25_would_be_bdt_by_descent_at_commencement_under_1_b_d_or_e_but_for_renunciation-true
        ],
        proves(section25_by_descent(s25_section22))).

test(section_25_section_24_resumption_preserves_bdt_descent_class) :-
    with_facts(s25_resumption,
        [ section25_citizenship_basis-section24_section13_registration,
          section25_was_bdt_by_descent_immediately_before_renunciation-true
        ],
        proves(section25_by_descent(s25_resumption))).

test(section_25_schedule_2_paragraph_1_uk_birth_is_by_descent) :-
    with_facts(s25_schedule2,
        [ section25_citizenship_basis-schedule2_paragraph1,
          born_in_uk-true,
          after_commencement-true
        ],
        proves(section25_by_descent(s25_schedule2))).

:- end_tests(british_nationality_sections_15_25).
