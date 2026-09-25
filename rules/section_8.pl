:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

% Section 8(1): the mandatory legacy route requires a qualifying pre-commencement marriage entitlement.
section8_entitled_to_registration(Person) :-
    fact(Person, section8_application_within_five_years, true),
    fact(Person, section8_legacy_1948_act_marriage_entitlement, true),
    fact(Person, section8_husband_became_british_at_commencement, true),
    fact(Person, section8_husband_never_renounced_before_application, true),
    fact(Person, section8_marriage_continued_through_application, true).

% Section 8(2): a discretionary route covers qualifying former marriages where the husband became British or would have but for death.
section8_may_register(Person) :-
    fact(Person, section8_application_within_five_years, true),
    fact(Person, section8_legacy_1948_act_marriage_entitlement, true),
    fact(Person, section8_no_longer_married_to_original_husband, true),
    fact(Person, section8_husband_became_british_or_would_but_for_death, true),
    fact(Person, secretary_of_state_approves_registration, true).

% Section 8(3): a current marriage and prior entitlement permit discretion despite the husband's renunciation.
section8_may_register(Person) :-
    fact(Person, section8_application_within_five_years, true),
    fact(Person, section8_applicant_married_on_application_date, true),
    fact(Person, section8_legacy_1948_act_marriage_entitlement, true),
    fact(Person, section8_current_husband_became_or_would_have_become_british, true),
    fact(Person, section8_current_husband_renounced_or_had_renounced, true),
    fact(Person, secretary_of_state_approves_registration, true).
