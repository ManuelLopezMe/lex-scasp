:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

% Section 10(4)(a)-(c): a qualifying connection can arise from the person's own qualifying UK history.
section10_qualifying_connection(Person) :-
    fact(Person, section10_self_connection_basis, Basis),
    section10_connection_basis_is_qualifying(Basis).

% Section 10(4)(a)-(c): a qualifying connection can arise from the father's qualifying UK history.
section10_qualifying_connection(Person) :-
    fact(Person, section10_father_connection_basis, Basis),
    section10_connection_basis_is_qualifying(Basis).

% Section 10(4)(a)-(c): a qualifying connection can arise from the paternal grandfather's qualifying UK history.
section10_qualifying_connection(Person) :-
    fact(Person, section10_paternal_grandfather_connection_basis, Basis),
    section10_connection_basis_is_qualifying(Basis).

% Section 10(4)(a): UK birth is one qualifying connection basis.
section10_connection_basis_is_qualifying(born_in_uk).

% Section 10(4)(b): UK naturalisation is one qualifying connection basis.
section10_connection_basis_is_qualifying(naturalised_in_uk).

% Section 10(4)(c): registration in the UK or specified historical territory is one qualifying basis.
section10_connection_basis_is_qualifying(registered_in_qualifying_territory).

% Section 10(1): the preserved 1964 Act resumption entitlement is an explicit legacy-law abstraction.
section10_legacy_resumption_route(Person) :-
    fact(Person, section10_would_have_been_entitled_under_1964_act, true),
    section10_qualifying_connection(Person).

% Section 10(1): the historic married-woman route is abstracted without reconstructing the repealed Act.
section10_legacy_resumption_route(Person) :-
    fact(Person, section10_would_have_been_entitled_under_1964_act, true),
    fact(Person, section10_woman_married_to_person_with_qualifying_connection, true).

% Section 10(3): a person cannot use the mandatory subsection (1) registration more than once.
section10_once_only_requirement(Person) :-
    fact(Person, section10_prior_subsection_1_registration, false).

% Section 10(1), (3): qualifying legacy resumption rights confer registration entitlement once.
section10_entitled_to_registration(Person) :-
    fact(Person, registration_application, true),
    section10_legacy_resumption_route(Person),
    section10_once_only_requirement(Person).

% Section 10(2): the discretionary route requires full capacity, prior renunciation, a qualifying connection, and application.
section10_may_register(Person) :-
    fact(Person, registration_application, true),
    fact(Person, full_capacity, true),
    fact(Person, section10_ceased_cukc_by_precommencement_renunciation, true),
    section10_qualifying_connection(Person),
    fact(Person, secretary_of_state_approves_registration, true).

% Section 10(2): the discretionary married-woman connection route is included as a distinct statutory alternative.
section10_may_register(Person) :-
    fact(Person, registration_application, true),
    fact(Person, full_capacity, true),
    fact(Person, section10_ceased_cukc_by_precommencement_renunciation, true),
    fact(Person, section10_woman_married_to_person_with_qualifying_connection, true),
    fact(Person, secretary_of_state_approves_registration, true).
