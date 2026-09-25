:- use_module(library(scasp)).
:- use_module('../facts/rdf_facts.pl').

% Section 7(1)(a): this predicate accepts the historic Immigration Act entitlement as an explicit counterfactual input.
section7_legacy_route_qualified(Person, route_a) :-
    fact(Person, section7_immigration_schedule_paragraph_2_3_entitlement, true).

% Section 7(1)(b): the alternative historic 1948 Act entitlement is an explicit counterfactual input.
section7_legacy_route_qualified(Person, route_b) :-
    fact(Person, section7_1948_act_section_8_entitled_at_commencement_and_application, true).

% Section 7(1): an application within five years after commencement is timely.
section7_ordinary_window(Person) :-
    fact(Person, section7_elapsed_years_after_commencement_or_majority, Years),
    Years >= 0,
    Years =< 5.

% Section 7(6): an application within eight years is timely only where the Secretary of State extends the period.
section7_extended_window(Person) :-
    fact(Person, section7_elapsed_years_after_commencement_or_majority, Years),
    Years >= 0,
    Years =< 8,
    fact(Person, section7_special_circumstances_extension, true).

% Section 7(6): the special extension has priority over the ordinary five-year deadline.
section7_priority(s7_special_extension, 20).

% Section 7(1): the ordinary period has lower priority than the special extension.
section7_priority(s7_ordinary_period, 10).

% Sections 7(1), 7(6), and 7(7): numeric priority represents the statutory extension to the filing period.
section7_higher_priority(HigherRule, LowerRule) :-
    section7_priority(HigherRule, HigherRank),
    section7_priority(LowerRule, LowerRank),
    HigherRank > LowerRank.

% Section 7(1)(a): the first historic route gives entitlement on a timely application.
section7_entitled_under_subsection_1(Person) :-
    fact(Person, registration_application, true),
    section7_legacy_route_qualified(Person, route_a),
    section7_ordinary_window(Person).

% Section 7(1)(b): the alternative historic route confers entitlement within the ordinary filing period.
section7_entitled_under_subsection_1(Person) :-
    fact(Person, registration_application, true),
    section7_legacy_route_qualified(Person, route_b),
    section7_ordinary_window(Person).

% Section 7(6): an extended timely application and qualifying legacy route confer the special entitlement.
section7_entitled_under_subsection_1(Person) :-
    fact(Person, registration_application, true),
    section7_extended_window(Person),
    section7_extended_route_qualified(Person, route_a),
    section7_higher_priority(s7_special_extension, s7_ordinary_period).

% Section 7(6): the extended route (b) also requires entitlement at the five-year endpoint.
section7_entitled_under_subsection_1(Person) :-
    fact(Person, registration_application, true),
    section7_extended_window(Person),
    section7_extended_route_qualified(Person, route_b),
    section7_higher_priority(s7_special_extension, s7_ordinary_period).

% Section 7(6): route (a)'s historic entitlement is preserved when the application window is extended.
section7_extended_route_qualified(Person, route_a) :-
    section7_legacy_route_qualified(Person, route_a).

% Section 7(6): route (b) extension requires entitlement on an application made at the end of the ordinary period.
section7_extended_route_qualified(Person, route_b) :-
    section7_legacy_route_qualified(Person, route_b),
    fact(Person, section7_route_b_entitled_at_five_year_endpoint, true).

% Section 7(2)(a): the pre-commencement ordinary-residence period must be positive and shorter than five years.
section7_precommencement_residence_requirement(Person) :-
    fact(Person, section7_precommencement_ordinary_residence_months, Months),
    Months > 0,
    Months < 60.

% Section 7(2)(b): ordinary residence must continue from commencement to the application.
section7_postcommencement_residence_requirement(Person) :-
    fact(Person, section7_ordinary_residence_continued_to_application, true).

% Section 7(2)(b): the applicant must have had the right of abode throughout the post-commencement period.
section7_right_of_abode_requirement(Person) :-
    fact(Person, section7_right_of_abode_throughout_postcommencement_period, true).

% Section 7(2)(c): at least five years of ordinary residence by application satisfies the duration requirement.
section7_five_year_duration_requirement(Person) :-
    fact(Person, section7_residence_months_at_application_including_service, Months),
    Months >= 60.

% Section 7(5): international-organisation service used for the residence calculation requires a close-connection determination.
section7_non_crown_service_approved(Person) :-
    fact(Person, section7_relevant_service_type, uk_member_international_organisation),
    fact(Person, section7_relies_on_non_crown_service, true),
    fact(Person, secretary_of_state_close_uk_connection_approval, true).

% Section 7(5): company or association service used for the residence calculation requires a close-connection determination.
section7_non_crown_service_approved(Person) :-
    fact(Person, section7_relevant_service_type, uk_established_company_or_association),
    fact(Person, section7_relies_on_non_crown_service, true),
    fact(Person, secretary_of_state_close_uk_connection_approval, true).

% Section 7(3)-(4): qualifying Crown service can be credited without the non-Crown close-connection determination.
section7_non_crown_service_approved(Person) :-
    fact(Person, section7_relevant_service_type, uk_crown).

% Section 7(2): ordinary residence duration without reliance on relevant service needs no close-connection determination.
section7_non_crown_service_approved(Person) :-
    fact(Person, section7_relies_on_non_crown_service, false).

% Section 7(8): special circumstances extend the subsection (2) application window to eight years.
section7_subsection_2_window(Person) :-
    fact(Person, section7_elapsed_years_after_commencement, Years),
    Years >= 0,
    Years =< 6.

% Section 7(8): the discretionary extension replaces the ordinary six-year subsection (2) window.
section7_subsection_2_window(Person) :-
    fact(Person, section7_elapsed_years_after_commencement, Years),
    Years >= 0,
    Years =< 8,
    fact(Person, section7_special_subsection_2_extension, true),
    section7_higher_priority(s7_special_extension, s7_ordinary_period).

% Section 7(2), (8): the residence entitlement is subject to its statutory filing window.
section7_entitled_under_subsection_2(Person) :-
    fact(Person, registration_application, true),
    section7_subsection_2_window(Person),
    section7_precommencement_residence_requirement(Person),
    section7_postcommencement_residence_requirement(Person),
    section7_right_of_abode_requirement(Person),
    section7_five_year_duration_requirement(Person),
    section7_non_crown_service_approved(Person).
