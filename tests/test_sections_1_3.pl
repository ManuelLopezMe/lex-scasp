:- use_module(library(plunit)).
:- use_module(library(scasp)).
:- use_module('../facts/rdf_facts.pl').
:- ensure_loaded('../rules/section_1.pl').
:- ensure_loaded('../rules/section_2.pl').
:- ensure_loaded('../rules/section_3.pl').

:- begin_tests(british_nationality_sections_1_3).

test(canonical_rdf_facts_derive_uk_birth_and_parent_citizenship) :-
    fact('https://example.org/bna#uk_birth_british_parent', born_in_uk, true),
    fact('https://example.org/bna#uk_birth_british_parent', parent_is_citizen, true).

test(section_1_birth_to_qualifying_parent) :-
    once(scasp(section1_british_citizen(
        'https://example.org/bna#uk_birth_british_parent'), [])).

test(section_1_birth_without_qualifying_parent, [fail]) :-
    scasp(section1_british_citizen(
        'https://example.org/bna#edge_uk_birth_no_qualifying_parent'), []).

test(section_1_special_circumstances_override_absence_limit) :-
    once(scasp(section1_ten_year_registration_entitled(
        'https://example.org/bna#edge_special_absence_discretion'), [])).

test(section_1_rebutted_abandonment_presumption, [fail]) :-
    scasp(section1_british_citizen(
        'https://example.org/bna#edge_abandonment_rebutted'), []).

test(section_2_parent_citizen_otherwise_than_by_descent) :-
    once(scasp(section2_british_citizen(
        'https://example.org/bna#overseas_birth_parent_by_own_right'), [])).

test(section_2_descent_parent_only_citizen_by_descent, [fail]) :-
    scasp(section2_british_citizen(
        'https://example.org/bna#descent_parent_only_by_descent'), []).

test(section_2_crown_service_exception_route) :-
    once(scasp(section2_british_citizen(
        'https://example.org/bna#descent_crown_service'), [])).

test(section_3_ordinary_parent_ancestry_and_residence) :-
    once(scasp(section3_entitled_under_subsection_2(
        'https://example.org/bna#edge_minor_parent_citizen_by_descent'), [])).

test(section_3_nonstateless_applicant_fails_residence_test, [fail]) :-
    scasp(section3_entitled_under_subsection_2(
        'https://example.org/bna#edge_parent_three_year_residence_271'), []).

test(section_3_stateless_exception_to_residence_requirement) :-
    once(scasp(section3_entitled_under_subsection_2(
        'https://example.org/bna#edge_stateless_parentage_met'), [])).

test(section_3_discretion_extends_application_period) :-
    once(scasp(section3_entitled_under_subsection_2(
        'https://example.org/bna#edge_six_year_extension'), [])).

:- end_tests(british_nationality_sections_1_3).
