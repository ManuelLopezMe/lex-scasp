:- use_module(library(plunit)).
:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').
:- ensure_loaded('../rules/section_4.pl').
:- ensure_loaded('../rules/section_5.pl').
:- ensure_loaded('../rules/section_6.pl').
:- ensure_loaded('../rules/section_7.pl').
:- ensure_loaded('../rules/section_8.pl').
:- ensure_loaded('../rules/section_9.pl').
:- ensure_loaded('../rules/section_10.pl').
:- ensure_loaded('../rules/section_11.pl').
:- ensure_loaded('../rules/section_12.pl').
:- ensure_loaded('../rules/section_13.pl').
:- ensure_loaded('../rules/section_14.pl').

:- begin_tests(british_nationality_sections_4_14).

% Each test uses temporary fact/3 inputs to isolate one hypothetical; the rules operate over the shared fact store.
with_facts(Person, Facts, Goal) :-
    setup_call_cleanup(
        maplist(assert_person_fact(Person), Facts),
        call(Goal),
        retractall(bna_facts:fact(Person, _, _))).

assert_person_fact(Person, Property-Value) :-
    assertz(bna_facts:fact(Person, Property, Value)).

proves(Goal) :-
    once(scasp(Goal, [])).

test(section_4_exact_absence_thresholds_entitle) :-
    with_facts(s4_boundary,
        [ section4_status-bdt_citizen,
          registration_application-true,
          section4_in_uk_at_five_year_period_start-true,
          section4_absence_days_five_years-450,
          section4_absence_days_last_twelve_months-90,
          section4_restricted_during_last_twelve_months-false,
          section4_in_uk_in_breach_during_five_years-false
        ],
        proves(section4_entitled_to_registration(s4_boundary))).

test(section_4_excess_absence_needs_special_circumstances_relief) :-
    with_facts(s4_relief,
        [ section4_status-british_overseas_citizen,
          registration_application-true,
          section4_settled_in_uk_immediately_before_commencement-true,
          section4_absence_days_five_years-451,
          section4_absence_days_last_twelve_months-91,
          section4_restricted_during_last_twelve_months-false,
          section4_in_uk_in_breach_during_five_years-false,
          section4_special_relief-five_year_absence,
          section4_special_relief-last_twelve_months_absence
        ],
        proves(section4_entitled_to_registration(s4_relief))).

test(section_4_special_relief_defeats_ordinary_absence_failure) :-
    with_facts(s4_absence_conflict,
        [ section4_status-bdt_citizen,
          registration_application-true,
          section4_in_uk_at_five_year_period_start-true,
          section4_absence_days_five_years-451,
          section4_absence_days_last_twelve_months-0,
          section4_restricted_during_last_twelve_months-false,
          section4_in_uk_in_breach_during_five_years-false,
          section4_special_relief-five_year_absence
        ],
        proves((section4_rule_candidate(
              s4_absence_conflict, section4,
              not_met(five_year_absence), s4_ordinary_absence_limit),
          section4_rule_candidate(
              s4_absence_conflict, section4,
              met(five_year_absence), s4_special_absence_relief),
          section4_rule_defeats(
              s4_absence_conflict, section4,
              s4_ordinary_absence_limit, s4_special_absence_relief),
          section4_five_year_absence_requirement(s4_absence_conflict)))).

test(section_4_451_days_without_relief_fails, [fail]) :-
    with_facts(s4_451_no_relief,
        [ section4_status-bdt_citizen,
          registration_application-true,
          section4_in_uk_at_five_year_period_start-true,
          section4_absence_days_five_years-451,
          section4_absence_days_last_twelve_months-90,
          section4_restricted_during_last_twelve_months-false,
          section4_in_uk_in_breach_during_five_years-false
        ],
        proves(section4_entitled_to_registration(s4_451_no_relief))).

test(section_4_current_restriction_cannot_be_disregarded, [fail]) :-
    with_facts(s4_current_restriction,
        [ section4_status-british_subject_under_act,
          registration_application-true,
          section4_in_uk_at_five_year_period_start-true,
          section4_absence_days_five_years-0,
          section4_absence_days_last_twelve_months-0,
          section4_restricted_during_last_twelve_months-true,
          section4_restriction_applies_on_application_date-true,
          section4_special_relief-past_immigration_restriction,
          section4_in_uk_in_breach_during_five_years-false
        ],
        proves(section4_entitled_to_registration(s4_current_restriction))).

test(section_4_past_restriction_and_breach_require_special_relief) :-
    with_facts(s4_relief_other_requirements,
        [ section4_status-bdt_citizen,
          registration_application-true,
          section4_in_uk_at_five_year_period_start-true,
          section4_absence_days_five_years-0,
          section4_absence_days_last_twelve_months-0,
          section4_restricted_during_last_twelve_months-true,
          section4_restriction_applies_on_application_date-false,
          section4_special_relief-past_immigration_restriction,
          section4_in_uk_in_breach_during_five_years-true,
          section4_special_relief-immigration_breach
        ],
        proves(section4_entitled_to_registration(s4_relief_other_requirements))).

test(section_4_special_service_route_requires_special_approval) :-
    with_facts(s4_service,
        [ section4_status-british_protected_person,
          registration_application-true,
          section4_qualifying_service-dependent_territory_crown_body,
          section4_special_circumstances_approval-true
        ],
        proves(section4_may_register_by_service(s4_service))).

test(section_5_treaty_national_bdt_citizen_entitled) :-
    with_facts(s5_treaty,
        [ section5_is_bdt_citizen-true,
          section5_treated_as_uk_national_for_community_treaties-true,
          registration_application-true
        ],
        proves(section5_entitled_to_registration(s5_treaty))).

test(section_5_non_bdt_person_not_covered, [fail]) :-
    with_facts(s5_other,
        [ section5_is_bdt_citizen-false,
          section5_treated_as_uk_national_for_community_treaties-true,
          registration_application-true
        ],
        proves(section5_entitled_to_registration(s5_other))).

test(section_6_general_naturalisation_uses_schedule_1_input) :-
    with_facts(s6_general,
        [ naturalisation_application-true,
          full_age-true,
          full_capacity-true,
          section6_schedule1_general_requirements_met-true,
          secretary_of_state_approves_naturalisation-true
        ],
        proves(section6_may_grant_naturalisation(s6_general))).

test(section_6_schedule_1_not_assumed, [fail]) :-
    with_facts(s6_unspecified,
        [ naturalisation_application-true,
          full_age-true,
          full_capacity-true,
          secretary_of_state_approves_naturalisation-true
        ],
        proves(section6_may_grant_naturalisation(s6_unspecified))).

test(section_6_spouse_route_has_distinct_schedule_1_test) :-
    with_facts(s6_spouse,
        [ naturalisation_application-true,
          full_age-true,
          full_capacity-true,
          married_to_british_citizen_on_application_date-true,
          section6_schedule1_spouse_requirements_met-true,
          secretary_of_state_approves_naturalisation-true
        ],
        proves(section6_may_grant_naturalisation(s6_spouse))).

test(section_7_five_year_route_at_boundary) :-
    with_facts(s7_five,
        [ registration_application-true,
          section7_elapsed_years_after_commencement_or_majority-5,
          section7_immigration_schedule_paragraph_2_3_entitlement-true
        ],
        proves(section7_entitled_under_subsection_1(s7_five))).

test(section_7_eight_year_extension_allows_route_a) :-
    with_facts(s7_extended,
        [ registration_application-true,
          section7_elapsed_years_after_commencement_or_majority-8,
          section7_immigration_schedule_paragraph_2_3_entitlement-true,
          section7_special_circumstances_extension-true
        ],
        proves(section7_entitled_under_subsection_1(s7_extended))).

test(section_7_route_b_extension_requires_five_year_endpoint_eligibility, [fail]) :-
    with_facts(s7_route_b_no_endpoint,
        [ registration_application-true,
          section7_elapsed_years_after_commencement_or_majority-7,
          section7_1948_act_section_8_entitled_at_commencement_and_application-true,
          section7_special_circumstances_extension-true
        ],
        proves(section7_entitled_under_subsection_1(s7_route_b_no_endpoint))).

test(section_7_residence_route_counts_sixty_months_with_right_of_abode) :-
    with_facts(s7_residence,
        [ registration_application-true,
          section7_elapsed_years_after_commencement-6,
          section7_precommencement_ordinary_residence_months-24,
          section7_ordinary_residence_continued_to_application-true,
          section7_right_of_abode_throughout_postcommencement_period-true,
          section7_residence_months_at_application_including_service-60,
          section7_relies_on_non_crown_service-false
        ],
        proves(section7_entitled_under_subsection_2(s7_residence))).

test(section_7_subsection_2_eight_year_extension) :-
    with_facts(s7_residence_extension,
        [ registration_application-true,
          section7_elapsed_years_after_commencement-8,
          section7_special_subsection_2_extension-true,
          section7_precommencement_ordinary_residence_months-24,
          section7_ordinary_residence_continued_to_application-true,
          section7_right_of_abode_throughout_postcommencement_period-true,
          section7_residence_months_at_application_including_service-60,
          section7_relies_on_non_crown_service-false
        ],
        proves(section7_entitled_under_subsection_2(s7_residence_extension))).

test(section_7_non_crown_service_requires_close_connection_approval) :-
    with_facts(s7_company_service,
        [ registration_application-true,
          section7_elapsed_years_after_commencement-6,
          section7_precommencement_ordinary_residence_months-24,
          section7_ordinary_residence_continued_to_application-true,
          section7_right_of_abode_throughout_postcommencement_period-true,
          section7_residence_months_at_application_including_service-60,
          section7_relevant_service_type-uk_established_company_or_association,
          section7_relies_on_non_crown_service-true,
          secretary_of_state_close_uk_connection_approval-true
        ],
        proves(section7_entitled_under_subsection_2(s7_company_service))).

test(section_8_mandatory_legacy_marriage_route) :-
    with_facts(s8_entitled,
        [ section8_application_within_five_years-true,
          section8_legacy_1948_act_marriage_entitlement-true,
          section8_husband_became_british_at_commencement-true,
          section8_husband_never_renounced_before_application-true,
          section8_marriage_continued_through_application-true
        ],
        proves(section8_entitled_to_registration(s8_entitled))).

test(section_8_discretionary_former_marriage_route) :-
    with_facts(s8_discretion,
        [ section8_application_within_five_years-true,
          section8_legacy_1948_act_marriage_entitlement-true,
          section8_no_longer_married_to_original_husband-true,
          section8_husband_became_british_or_would_but_for_death-true,
          secretary_of_state_approves_registration-true
        ],
        proves(section8_may_register(s8_discretion))).

test(section_9_birth_and_application_window_edges_inclusive) :-
    with_facts(s9_boundary,
        [ section9_born_in_foreign_country-true,
          section9_months_after_commencement_at_birth-60,
          section9_months_after_birth_at_application-12,
          registration_application-true,
          section9_father_subsection_2_requirements_met-true,
          section9_hypothetical_1948_act_registration_would_give_right_of_abode-true
        ],
        proves(section9_entitled_to_registration(s9_boundary))).

test(section_9_birth_after_five_year_window_does_not_qualify, [fail]) :-
    with_facts(s9_late_birth,
        [ section9_born_in_foreign_country-true,
          section9_months_after_commencement_at_birth-61,
          section9_months_after_birth_at_application-12,
          registration_application-true,
          section9_father_subsection_2_requirements_met-true,
          section9_hypothetical_1948_act_registration_would_give_right_of_abode-true
        ],
        proves(section9_entitled_to_registration(s9_late_birth))).

test(section_10_paternal_grandfather_connection_and_once_only) :-
    with_facts(s10_connection,
        [ registration_application-true,
          section10_would_have_been_entitled_under_1964_act-true,
          section10_paternal_grandfather_connection_basis-born_in_uk,
          section10_prior_subsection_1_registration-false
        ],
        proves(section10_entitled_to_registration(s10_connection))).

test(section_10_prior_mandatory_registration_blocks_second_entitlement, [fail]) :-
    with_facts(s10_twice,
        [ registration_application-true,
          section10_would_have_been_entitled_under_1964_act-true,
          section10_self_connection_basis-naturalised_in_uk,
          section10_prior_subsection_1_registration-true
        ],
        proves(section10_entitled_to_registration(s10_twice))).

test(section_11_general_commencement_rule) :-
    with_facts(s11_general,
        [ section11_cukc_immediately_before_commencement-true,
          section11_right_of_abode_immediately_before_commencement-true
        ],
        proves(section11_becomes_british_citizen(s11_general))).

test(section_11_maternal_stateless_exception_requires_one_of_two_conditions, [fail]) :-
    with_facts(s11_maternal_exception,
        [ section11_cukc_immediately_before_commencement-true,
          section11_right_of_abode_immediately_before_commencement-true,
          section11_registered_under_1964_stateless_act_on_maternal_ground-true,
          section11_mother_becomes_british_or_would_but_for_death-false,
          section11_right_of_abode_under_immigration_act_2_1_c-false
        ],
        proves(section11_becomes_british_citizen(s11_maternal_exception))).

test(section_11_maternal_stateless_exception_satisfied_by_alternative_roa) :-
    with_facts(s11_maternal_exception_met,
        [ section11_cukc_immediately_before_commencement-true,
          section11_right_of_abode_immediately_before_commencement-true,
          section11_registered_under_1964_stateless_act_on_maternal_ground-true,
          section11_right_of_abode_under_immigration_act_2_1_c-true
        ],
        proves(section11_becomes_british_citizen(s11_maternal_exception_met))).

test(section_11_maternal_exception_defeats_ordinary_commencement_rule) :-
    with_facts(s11_priority_conflict,
        [ section11_cukc_immediately_before_commencement-true,
          section11_right_of_abode_immediately_before_commencement-true,
          section11_registered_under_1964_stateless_act_on_maternal_ground-true,
          section11_mother_becomes_british_or_would_but_for_death-false,
          section11_right_of_abode_under_immigration_act_2_1_c-false
        ],
        proves((section11_rule_candidate(
              s11_priority_conflict, section11,
              becomes_british_citizen, s11_ordinary_commencement_rule),
          section11_rule_candidate(
              s11_priority_conflict, section11,
              does_not_become_british_citizen,
              s11_maternal_stateless_exception),
          section11_rule_defeats(
              s11_priority_conflict, section11,
              s11_ordinary_commencement_rule,
              s11_maternal_stateless_exception),
          section11_does_not_become_british_citizen(s11_priority_conflict)))).

test(section_12_declaration_and_six_month_nationality_safeguard_retain_status) :-
    with_facts(s12_retain,
        [ british_citizen-true,
          full_age-true,
          full_capacity-true,
          section12_declaration_made_in_prescribed_manner-true,
          section12_secretary_satisfied_other_nationality_will_be_held_or_acquired-true,
          section12_made_during_qualifying_war-false,
          section12_secretary_withholds_registration-false,
          section12_other_nationality_held_at_registration-false,
          section12_acquired_other_nationality_within_six_months-false
        ],
        proves(section12_declaration_registered(s12_retain))).

test(section_12_failure_to_acquire_another_nationality_restores_status) :-
    with_facts(s12_retain_status,
        [ british_citizen-true,
          full_age-true,
          full_capacity-true,
          section12_declaration_made_in_prescribed_manner-true,
          section12_secretary_satisfied_other_nationality_will_be_held_or_acquired-true,
          section12_made_during_qualifying_war-false,
          section12_secretary_withholds_registration-false,
          section12_other_nationality_held_at_registration-false,
          section12_acquired_other_nationality_within_six_months-false
        ],
        proves(section12_remains_british_citizen(s12_retain_status))).

test(section_12_registration_with_another_nationality_causes_cessation) :-
    with_facts(s12_cease,
        [ british_citizen-true,
          full_age-true,
          full_capacity-true,
          section12_declaration_made_in_prescribed_manner-true,
          section12_secretary_satisfied_other_nationality_will_be_held_or_acquired-true,
          section12_made_during_qualifying_war-false,
          section12_secretary_withholds_registration-false,
          section12_other_nationality_held_at_registration-true
        ],
        proves(section12_ceases_to_be_british_citizen(s12_cease))).

test(section_12_wartime_withholding_overrides_registration) :-
    with_facts(s12_war,
        [ british_citizen-true,
          full_age-true,
          full_capacity-true,
          section12_declaration_made_in_prescribed_manner-true,
          section12_secretary_satisfied_other_nationality_will_be_held_or_acquired-true,
          section12_made_during_qualifying_war-true,
          section12_secretary_withholds_registration-true
        ],
        proves(section12_wartime_withholding_applies(s12_war))).

test(section_12_wartime_withholding_blocks_registration, [fail]) :-
    with_facts(s12_war_blocks,
        [ british_citizen-true,
          full_age-true,
          full_capacity-true,
          section12_declaration_made_in_prescribed_manner-true,
          section12_secretary_satisfied_other_nationality_will_be_held_or_acquired-true,
          section12_made_during_qualifying_war-true,
          section12_secretary_withholds_registration-true
        ],
        proves(section12_declaration_registered(s12_war_blocks))).

test(section_12_wartime_withholding_defeats_registration_candidate) :-
    with_facts(s12_priority_conflict,
        [ british_citizen-true,
          full_age-true,
          full_capacity-true,
          section12_declaration_made_in_prescribed_manner-true,
          section12_secretary_satisfied_other_nationality_will_be_held_or_acquired-true,
          section12_made_during_qualifying_war-true,
          section12_secretary_withholds_registration-true
        ],
        proves((section12_rule_candidate(
              s12_priority_conflict, section12,
              declaration_registered, s12_ordinary_registration),
          section12_rule_candidate(
              s12_priority_conflict, section12,
              declaration_withheld, s12_wartime_withholding),
          section12_rule_defeats(
              s12_priority_conflict, section12,
              s12_ordinary_registration, s12_wartime_withholding),
          section12_accepted_outcome(
              s12_priority_conflict, section12, declaration_withheld)))).

test(section_13_mandatory_resumption_available_once) :-
    with_facts(s13_entitled,
        [ section13_ceased_british_citizen_by_renunciation-true,
          full_capacity-true,
          registration_application-true,
          section13_renunciation_necessary_for_other_nationality-true,
          section13_prior_subsection_1_registration-false
        ],
        proves(section13_entitled_to_registration(s13_entitled))).

test(section_13_second_mandatory_resumption_not_entitled, [fail]) :-
    with_facts(s13_second,
        [ section13_ceased_british_citizen_by_renunciation-true,
          full_capacity-true,
          registration_application-true,
          section13_renunciation_necessary_for_other_nationality-true,
          section13_prior_subsection_1_registration-true
        ],
        proves(section13_entitled_to_registration(s13_second))).

test(section_13_discretionary_route_does_not_require_necessity) :-
    with_facts(s13_discretion,
        [ section13_ceased_british_citizen_by_renunciation-true,
          full_capacity-true,
          registration_application-true,
          secretary_of_state_approves_registration-true
        ],
        proves(section13_may_register(s13_discretion))).

test(section_14_postcommencement_section_2_route_is_by_descent) :-
    with_facts(s14_section2,
        [ section14_citizenship_basis-section2_1_a_only,
          born_outside_uk-true,
          after_commencement-true
        ],
        proves(section14_by_descent(s14_section2))).

test(section_14_service_exception_defeats_legacy_descent_classification) :-
    with_facts(s14_exception,
        [ born_outside_uk-true,
          before_commencement-true,
          section14_subsection_1_b_historic_conditions_met-true,
          section14_father_served_outside_uk_at_birth-true,
          section14_father_service_type-uk_designated_service,
          section14_service_recruited_in_uk-true
        ],
        proves(section14_not_by_descent(s14_exception))).

test(section_14_service_exception_blocks_legacy_by_descent, [fail]) :-
    with_facts(s14_exception_not_descent,
        [ born_outside_uk-true,
          before_commencement-true,
          section14_subsection_1_b_historic_conditions_met-true,
          section14_father_served_outside_uk_at_birth-true,
          section14_father_service_type-uk_designated_service,
          section14_service_recruited_in_uk-true
        ],
        proves(section14_by_descent(s14_exception_not_descent))).

test(section_14_service_exception_defeats_legacy_descent_candidate) :-
    with_facts(s14_priority_conflict,
        [ born_outside_uk-true,
          before_commencement-true,
          section14_subsection_1_b_historic_conditions_met-true,
          section14_father_served_outside_uk_at_birth-true,
          section14_father_service_type-uk_designated_service,
          section14_service_recruited_in_uk-true
        ],
        proves((section14_rule_candidate(
              s14_priority_conflict, section14, by_descent,
              s14_legacy_descent),
          section14_rule_candidate(
              s14_priority_conflict, section14, not_by_descent,
              s14_service_exception),
          section14_rule_defeats(
              s14_priority_conflict, section14, s14_legacy_descent,
              s14_service_exception),
          section14_not_by_descent(s14_priority_conflict)))).

test(section_14_without_service_exception_retains_legacy_descent_classification) :-
    with_facts(s14_legacy,
        [ born_outside_uk-true,
          before_commencement-true,
          section14_subsection_1_b_historic_conditions_met-true
        ],
        proves(section14_by_descent(s14_legacy))).

test(section_14_section_5_registration_is_by_descent) :-
    with_facts(s14_section5,
        [ section14_citizenship_basis-section5_registration
        ],
        proves(section14_by_descent(s14_section5))).

:- end_tests(british_nationality_sections_4_14).
