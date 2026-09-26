:- use_module(library(plunit)).
:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').
:- ensure_loaded('../rules/section_1.pl').
:- ensure_loaded('../rules/section_2.pl').
:- ensure_loaded('../rules/section_3.pl').

:- begin_tests(british_nationality_sections_1_3).

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

test(section_1_birth_to_qualifying_parent) :-
    with_facts(s1_birth_qualifying_parent,
        [ born_in_uk-true,
          after_commencement-true,
          parent_is_citizen-true
        ],
        proves(section1_british_citizen(s1_birth_qualifying_parent))).

test(section_1_birth_without_qualifying_parent, [fail]) :-
    with_facts(s1_birth_no_qualifying_parent,
        [ born_in_uk-true,
          after_commencement-true
        ],
        proves(section1_british_citizen(s1_birth_no_qualifying_parent))).

test(section_1_special_circumstances_override_absence_limit) :-
    with_facts(s1_special_absence_discretion,
        [ born_in_uk-true,
          after_commencement-true,
          age_at_application-10,
          registration_application-true,
          secretary_of_state_special_circumstances-true
        ],
        proves(section1_ten_year_registration_entitled(
            s1_special_absence_discretion))).

test(section_1_rebutted_abandonment_presumption, [fail]) :-
    with_facts(s1_abandonment_rebutted,
        [ found_abandoned_in_uk-true,
          after_commencement-true,
          contrary_evidence_to_abandonment_presumption-true
        ],
        proves(section1_british_citizen(s1_abandonment_rebutted))).

test(section_1_abandonment_candidates_resolve_by_priority) :-
    with_facts(s1_abandonment_conflict,
        [ found_abandoned_in_uk-true,
          after_commencement-true,
          contrary_evidence_to_abandonment_presumption-true
        ],
        proves((section1_rule_candidate(
              s1_abandonment_conflict, section1_abandonment,
              presumed_qualifying_parent, s1_abandonment_presumption),
          section1_rule_candidate(
              s1_abandonment_conflict, section1_abandonment,
              presumption_rebutted, s1_contrary_evidence),
          section1_rule_defeats(
              s1_abandonment_conflict, section1_abandonment,
              s1_abandonment_presumption, s1_contrary_evidence),
          section1_abandonment_presumption_defeated(s1_abandonment_conflict)))).

test(section_1_birth_status_defeats_registration_candidate) :-
    with_facts(s1_birth_registration_conflict,
        [ born_in_uk-true,
          after_commencement-true,
          parent_is_citizen-true,
          minor_at_application-true,
          registration_application-true,
          parent_became_qualifying-true
        ],
        proves((section1_rule_candidate(
              s1_birth_registration_conflict, section1_registration,
              already_citizen, s1_birth_status),
          section1_rule_candidate(
              s1_birth_registration_conflict, section1_registration,
              registration_entitlement, s1_minor_registration),
          section1_rule_defeats(
              s1_birth_registration_conflict, section1_registration,
              s1_minor_registration, s1_birth_status),
          section1_accepted_outcome(
              s1_birth_registration_conflict, section1_registration,
              already_citizen)))).

test(section_2_parent_citizen_otherwise_than_by_descent) :-
    with_facts(s2_parent_by_own_right,
        [ born_outside_uk-true,
          after_commencement-true,
          parent_is_citizen_otherwise_than_descent-true
        ],
        proves(section2_british_citizen(s2_parent_by_own_right))).

test(section_2_descent_parent_only_citizen_by_descent, [fail]) :-
    with_facts(s2_parent_by_descent_only,
        [ born_outside_uk-true,
          after_commencement-true,
          parent_is_citizen_by_descent-true
        ],
        proves(section2_british_citizen(s2_parent_by_descent_only))).

test(section_2_crown_service_exception_route) :-
    with_facts(s2_crown_service,
        [ born_outside_uk-true,
          after_commencement-true,
          parent_has_qualifying_service-true
        ],
        proves(section2_british_citizen(s2_crown_service))).

test(section_3_ordinary_parent_ancestry_and_residence) :-
    with_facts(s3_ordinary_ancestry_and_residence,
        [ born_outside_uk-true,
          born_stateless-false,
          registration_application-true,
          application_months_after_birth-11,
          parent_is_citizen_by_descent-true,
          section3_parent_ancestry_qualified-true,
          section3_parent_in_uk_at_start-true,
          section3_period_ends_by_birth-true,
          section3_parent_absence_days-100
        ],
        proves(section3_entitled_under_subsection_2(
            s3_ordinary_ancestry_and_residence))).

test(section_3_nonstateless_applicant_fails_residence_test, [fail]) :-
    with_facts(s3_nonstateless_residence_fails,
        [ born_outside_uk-true,
          born_stateless-false,
          registration_application-true,
          application_months_after_birth-8,
          parent_is_citizen_by_descent-true,
          section3_parent_ancestry_qualified-true,
          section3_parent_in_uk_at_start-true,
          section3_period_ends_by_birth-true,
          section3_parent_absence_days-271
        ],
        proves(section3_entitled_under_subsection_2(
            s3_nonstateless_residence_fails))).

test(section_3_stateless_exception_to_residence_requirement) :-
    with_facts(s3_stateless_parentage_met,
        [ born_outside_uk-true,
          born_stateless-true,
          registration_application-true,
          application_months_after_birth-5,
          parent_is_citizen_by_descent-true,
          section3_parent_ancestry_qualified-true
        ],
        proves(section3_entitled_under_subsection_2(
            s3_stateless_parentage_met))).

test(section_3_discretion_extends_application_period) :-
    with_facts(s3_six_year_extension,
        [ born_outside_uk-true,
          born_stateless-false,
          registration_application-true,
          application_months_after_birth-72,
          secretary_of_state_special_circumstances-true,
          parent_is_citizen_by_descent-true,
          section3_parent_ancestry_qualified-true,
          section3_parent_in_uk_at_start-true,
          section3_period_ends_by_birth-true,
          section3_parent_absence_days-200
        ],
        proves(section3_entitled_under_subsection_2(s3_six_year_extension))).

test(section_3_minor_route_requires_family_residence_and_consent) :-
    with_facts(s3_minor_family_requirements,
        [ born_outside_uk-true,
          minor_at_application-true,
          registration_application-true,
          parent_is_citizen_by_descent-true,
          section3_subsection_5_family_residence_and_consent_requirements_met-true,
          parents_consent_to_registration-true
        ],
        proves(section3_entitled_under_subsection_5(
            s3_minor_family_requirements))).

test(section_3_minor_route_rejects_missing_family_residence_or_consent, [fail]) :-
    with_facts(s3_minor_missing_family_requirements,
        [ born_outside_uk-true,
          minor_at_application-true,
          registration_application-true,
          parent_is_citizen_by_descent-true
        ],
        proves(section3_entitled_under_subsection_5(
            s3_minor_missing_family_requirements))).

:- end_tests(british_nationality_sections_1_3).
