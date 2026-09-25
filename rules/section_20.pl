:- use_module(library(scasp)).
:- use_module('../facts/rdf_facts.pl').

% Section 20(1): the mandatory route requires a timely application, historical 1948 Act marriage entitlement, husband becoming a BDT citizen, no renunciation and continuous marriage.
section20_entitled_to_registration(Person) :-
    fact(Person, section20_applicant_was_wife_immediately_before_commencement, true),
    fact(Person, registration_application, true),
    fact(Person, section20_application_within_five_years_after_commencement, true),
    fact(Person, section20_1948_act_section_6_2_marriage_entitlement, true),
    fact(Person, section20_husband_became_bdt_citizen_at_commencement, true),
    fact(Person, section20_husband_did_not_renounce_bdt_citizenship_before_application, true),
    fact(Person, section20_marriage_continued_through_application, true).

% Section 20(2): the Secretary of State may register a woman whose former husband's historic BDT citizenship route matured at commencement.
section20_may_register(Person) :-
    fact(Person, registration_application, true),
    fact(Person, section20_application_within_five_years_after_commencement, true),
    fact(Person, section20_1948_act_section_6_2_marriage_entitlement, true),
    fact(Person, section20_no_longer_married_to_historic_husband, true),
    fact(Person, section20_husband_became_bdt_at_commencement_or_would_but_for_death, true),
    fact(Person, secretary_of_state_approves_registration, true).

% Section 20(3): the Secretary of State may register a woman married at application to a man whose BDT route was defeated by renunciation.
section20_may_register(Person) :-
    fact(Person, registration_application, true),
    fact(Person, section20_application_within_five_years_after_commencement, true),
    fact(Person, section20_applicant_married_at_application, true),
    fact(Person, section20_1948_act_section_6_2_entitlement_by_current_husband, true),
    fact(Person, section20_husband_became_bdt_then_renounced_or_would_but_for_cukc_renunciation, true),
    fact(Person, secretary_of_state_approves_registration, true).
