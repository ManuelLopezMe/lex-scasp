:- use_module(library(scasp)).
:- use_module('../facts/rdf_facts.pl').

% Section 28(1)-(3): an application within five years after commencement meets the statutory application window.
section28_application_window_requirement(Person) :-
    fact(Person, section28_months_after_commencement_at_application, Months),
    Months >= 0,
    Months =< 60.

% Section 28(1): the woman was the wife of a CUKC immediately before commencement.
section28_initial_marriage_requirement(Person) :-
    fact(Person, section28_was_wife_of_cukc_immediately_before_commencement, true).

% Section 28(1)(a): the woman would have been entitled to CUKC registration under Section 6(2) of the 1948 Act by marriage.
section28_section6_2_entitlement_requirement(Person) :-
    fact(Person, section28_would_be_entitled_under_1948_act_section_6_2, true).

% Section 28(1)(b): the husband became a BOC at commencement and did not cease to be one by renunciation before the application.
section28_husband_continuous_boc_requirement(Person) :-
    fact(Person, section28_husband_became_boc_at_commencement, true),
    fact(Person, section28_husband_did_not_cease_boc_by_renunciation_before_application, true).

% Section 28(1)(c): the woman remained married to the husband throughout the period up to application.
section28_married_throughout_requirement(Person) :-
    fact(Person, section28_remained_married_to_husband_throughout_period, true).

% Section 28(1): the woman is entitled to registration if all subsection (1) conditions are met.
section28_entitled_to_registration(Person) :-
    fact(Person, registration_application, true),
    section28_application_window_requirement(Person),
    section28_initial_marriage_requirement(Person),
    section28_section6_2_entitlement_requirement(Person),
    section28_husband_continuous_boc_requirement(Person),
    section28_married_throughout_requirement(Person).

% Section 28(2)(a): the woman would have qualified under the 1948 Act and is no longer married to that man on application.
section28_former_marriage_entitlement_requirement(Person) :-
    fact(Person, section28_would_be_entitled_under_1948_act_section_6_2, true),
    fact(Person, section28_no_longer_married_to_historical_husband_on_application, true).

% Section 28(2)(b): the man became a BOC at commencement or would have done so but for his death.
section28_husband_boc_or_would_but_for_death_requirement(Person) :-
    fact(Person, section28_husband_became_boc_at_commencement, true).

% Section 28(2)(b): death counterfactual supplies the alternative to the man becoming a BOC at commencement.
section28_husband_boc_or_would_but_for_death_requirement(Person) :-
    fact(Person, section28_husband_would_become_boc_at_commencement_but_for_death, true).

% Section 28(2): the Secretary of State may register a woman satisfying the former-marriage and husband-status conditions.
section28_may_register_former_marriage(Person) :-
    fact(Person, registration_application, true),
    section28_application_window_requirement(Person),
    section28_former_marriage_entitlement_requirement(Person),
    section28_husband_boc_or_would_but_for_death_requirement(Person),
    fact(Person, secretary_of_state_approves_registration, true).

% Section 28(3)(a): the woman would have qualified under the 1948 Act through her being or having been married to her current husband.
section28_current_husband_entitlement_requirement(Person) :-
    fact(Person, section28_would_be_entitled_under_1948_act_section_6_2_through_current_husband, true).

% Section 28(3)(b)(i): the current husband became a BOC and ceased to be one by renunciation.
section28_husband_renunciation_route_requirement(Person) :-
    fact(Person, section28_current_husband_became_boc_at_commencement, true),
    fact(Person, section28_current_husband_ceased_boc_by_renunciation, true).

% Section 28(3)(b)(ii): the current husband would have become a BOC but for renouncing CUKC before commencement.
section28_husband_renunciation_route_requirement(Person) :-
    fact(Person, section28_current_husband_would_become_boc_but_for_cukc_renunciation, true).

% Section 28(3): the Secretary of State may register a woman married to the qualifying current husband on application.
section28_may_register_current_marriage(Person) :-
    fact(Person, registration_application, true),
    section28_application_window_requirement(Person),
    fact(Person, section28_married_to_husband_on_application_date, true),
    section28_current_husband_entitlement_requirement(Person),
    section28_husband_renunciation_route_requirement(Person),
    fact(Person, secretary_of_state_approves_registration, true).
