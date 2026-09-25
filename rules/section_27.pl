:- use_module(library(scasp)).
:- use_module('../facts/rdf_facts.pl').

% Section 27(1): the Secretary of State may register a person on an application made while the person is a minor.
section27_may_register_minor(Person) :-
    fact(Person, section27_application_while_minor, true),
    fact(Person, secretary_of_state_approves_registration, true).

% Section 27(2): a birth within five years after commencement meets the statutory birth window.
section27_birth_window_requirement(Person) :-
    fact(Person, section27_months_after_commencement_at_birth, Months),
    Months >= 0,
    Months =< 60.

% Section 27(2): an application within twelve months after birth meets the statutory application window.
section27_application_window_requirement(Person) :-
    fact(Person, section27_months_after_birth_at_application, Months),
    Months >= 0,
    Months =< 12.

% Section 27(2)(a), applying Section 9(2)(a): the father's historic status, marriage and residence requirements are an explicit determination.
section27_father_section9_subsection_2_a_requirements_met(Person) :-
    fact(Person, section27_father_section9_subsection_2_a_requirements_met, true).

% Section 27(2)(a), applying Section 9(2)(b)(i) as modified: the father became at least one of the three specified citizenships and continuously held at least one during the relevant period.
section27_father_adapted_section9_subsection_2_b_requirements_met(Person) :-
    fact(Person, section27_father_adapted_section9_subsection_2_b_i_requirements_met, true).

% Section 27(2)(a), applying Section 9(2)(b)(ii) as modified: the father would have become at least one of the three specified citizenships at commencement but for his death.
section27_father_adapted_section9_subsection_2_b_requirements_met(Person) :-
    fact(Person, section27_father_adapted_section9_subsection_2_b_ii_counterfactual_met, true).

% Section 27(2)(b): the pre-commencement birth and CUKC counterfactual would result in BOC status under Section 26.
section27_section26_counterfactual_requirement(Person) :-
    fact(Person, section27_would_become_boc_under_section26_in_precommencement_birth_counterfactual, true).

% Section 27(2): entitlement requires qualifying birth and application periods, a registration application, the adapted Section 9 father tests, and the Section 26 counterfactual.
section27_entitled_to_registration(Person) :-
    fact(Person, section27_born_in_foreign_country, true),
    section27_birth_window_requirement(Person),
    section27_application_window_requirement(Person),
    fact(Person, registration_application, true),
    section27_father_section9_subsection_2_a_requirements_met(Person),
    section27_father_adapted_section9_subsection_2_b_requirements_met(Person),
    section27_section26_counterfactual_requirement(Person).
