:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

% Section 22(4)(a): the applicant or an ancestor in the specified line was born in a dependent territory.
section22_appropriate_qualifying_connection(Person) :-
    fact(Person, section22_connection_qualification, birth_in_dependent_territory).

% Section 22(4)(b): the applicant or an ancestor in the specified line was naturalised in a dependent territory.
section22_appropriate_qualifying_connection(Person) :-
    fact(Person, section22_connection_qualification, naturalisation_in_dependent_territory).

% Section 22(4)(c): the applicant or an ancestor in the specified line was registered as a CUKC in a dependent territory.
section22_appropriate_qualifying_connection(Person) :-
    fact(Person, section22_connection_qualification, cukc_registration_in_dependent_territory).

% Section 22(4)(d): the applicant or an ancestor in the specified line became a British subject by dependent-territory annexation.
section22_appropriate_qualifying_connection(Person) :-
    fact(Person, section22_connection_qualification, british_subject_by_dependent_territory_annexation).

% Section 22(1): the once-only entitlement replaces the qualifying-connection route under section 1(1) of the 1964 Act.
section22_entitled_to_registration(Person) :-
    fact(Person, registration_application, true),
    fact(Person, section22_would_have_been_entitled_under_1964_act_for_territory_connection, true),
    section22_appropriate_qualifying_connection(Person),
    fact(Person, section22_prior_subsection_1_registration, false).

% Section 22(1): a woman may qualify for the mandatory route through the appropriate connection of a person to whom she was married before commencement.
section22_entitled_to_registration(Person) :-
    fact(Person, registration_application, true),
    fact(Person, section22_woman, true),
    fact(Person, section22_would_have_been_entitled_under_1964_act_for_territory_connection, true),
    fact(Person, section22_spouse_has_appropriate_qualifying_connection, true),
    fact(Person, section22_prior_subsection_1_registration, false).

% Section 22(1), (3): prior use of the entitlement is an express bar to another mandatory registration.
section22_not_entitled_to_second_registration(Person) :-
    fact(Person, section22_would_have_been_entitled_under_1964_act_for_territory_connection, true),
    fact(Person, section22_prior_subsection_1_registration, true).

% Section 22(2): the Secretary of State may register a full-capacity former CUKC renouncer with the specified territorial connection.
section22_may_register(Person) :-
    fact(Person, registration_application, true),
    fact(Person, full_capacity, true),
    fact(Person, section22_ceased_to_be_cukc_by_renunciation_before_commencement, true),
    section22_appropriate_qualifying_connection(Person),
    fact(Person, secretary_of_state_approves_registration, true).

% Section 22(2): the discretionary connection may instead arise through the applicant's spouse.
section22_may_register(Person) :-
    fact(Person, registration_application, true),
    fact(Person, full_capacity, true),
    fact(Person, section22_woman, true),
    fact(Person, section22_ceased_to_be_cukc_by_renunciation_before_commencement, true),
    fact(Person, section22_spouse_has_appropriate_qualifying_connection, true),
    fact(Person, secretary_of_state_approves_registration, true).
