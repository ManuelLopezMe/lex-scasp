:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

% Section 17(1): the Secretary of State may register a person on an application made while the person is a minor.
section17_may_register_minor(Person) :-
    fact(Person, section17_application_while_minor, true),
    fact(Person, secretary_of_state_approves_registration, true).

% Section 17(2)(a): the overseas-born applicant's parent was a BDT citizen by descent at the applicant's birth.
section17_parent_ancestry_requirement(Person) :-
    fact(Person, section17_parent_bdt_citizen_by_descent_at_applicant_birth, true).

% Section 17(2)(b)(i): a grandparent was a BDT citizen otherwise than by descent at the parent's birth.
section17_grandparent_requirement(Person) :-
    fact(Person, section17_grandparent_bdt_otherwise_than_by_descent_at_parent_birth, true).

% Section 17(2)(b)(ii): the grandparent became a BDT citizen otherwise than by descent at commencement.
section17_grandparent_requirement(Person) :-
    fact(Person, section17_grandparent_became_bdt_otherwise_than_by_descent_at_commencement, true).

% Section 17(2)(b)(ii): the grandparent would have become such a citizen at commencement but for death.
section17_grandparent_requirement(Person) :-
    fact(Person, section17_grandparent_would_become_bdt_otherwise_than_by_descent_but_for_death, true).

% Section 17(2)(c): the parent was in a dependent territory at the start of a qualifying three-year period and absent no more than 270 days.
section17_parent_residence_requirement(Person) :-
    fact(Person, section17_parent_three_year_residence_before_birth_met, true).

% Section 17(2)-(3): a non-stateless overseas-born person is entitled within twelve months if ancestry and residence requirements are met.
section17_entitled_to_birth_registration(Person) :-
    fact(Person, born_outside_dependent_territories, true),
    fact(Person, section17_application_within_twelve_months_of_birth, true),
    fact(Person, section17_born_stateless, false),
    section17_parent_ancestry_requirement(Person),
    section17_grandparent_requirement(Person),
    section17_parent_residence_requirement(Person).

% Section 17(2)-(3): a stateless overseas-born person is entitled within twelve months if ancestry requirements are met; subsection (2)(c) does not apply.
section17_entitled_to_birth_registration(Person) :-
    fact(Person, born_outside_dependent_territories, true),
    fact(Person, section17_application_within_twelve_months_of_birth, true),
    fact(Person, section17_born_stateless, true),
    section17_parent_ancestry_requirement(Person),
    section17_grandparent_requirement(Person).

% Section 17(2)-(4): a non-stateless person may use the extended window if special circumstances are approved and residence is met.
section17_entitled_to_birth_registration(Person) :-
    fact(Person, born_outside_dependent_territories, true),
    fact(Person, section17_application_within_six_years_of_birth, true),
    fact(Person, section17_secretary_approves_six_year_extension, true),
    fact(Person, section17_born_stateless, false),
    section17_parent_ancestry_requirement(Person),
    section17_grandparent_requirement(Person),
    section17_parent_residence_requirement(Person).

% Section 17(2)-(4): a stateless person may use the extended window without the subsection (2)(c) residence requirement.
section17_entitled_to_birth_registration(Person) :-
    fact(Person, born_outside_dependent_territories, true),
    fact(Person, section17_application_within_six_years_of_birth, true),
    fact(Person, section17_secretary_approves_six_year_extension, true),
    fact(Person, section17_born_stateless, true),
    section17_parent_ancestry_requirement(Person),
    section17_grandparent_requirement(Person).

% Section 17(5)(a): a parent was a BDT citizen by descent at the applicant's birth.
section17_parent_descent_at_birth(Person) :-
    fact(Person, section17_parent_bdt_citizen_by_descent_at_applicant_birth, true).

% Section 17(5)(b)-(c), (6): the shared-territory, absence and applicable family-reference requirements are supplied as one external determination.
section17_family_residence_and_consent_requirements(Person) :-
    fact(Person, section17_subsection_5_family_residence_and_consent_requirements_met, true).

% Section 17(5)-(6): a minor born outside the territories is entitled if the parent, family residence, absence and consent requirements are met.
section17_entitled_to_minor_registration(Person) :-
    fact(Person, born_outside_dependent_territories, true),
    fact(Person, section17_application_while_minor, true),
    section17_parent_descent_at_birth(Person),
    section17_family_residence_and_consent_requirements(Person).
