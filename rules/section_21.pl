:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

% Section 21(a)-(b): timely foreign-country birth registration within five years of commencement follows the adapted section 9 father tests and section 23(1)(b) counterfactual.
section21_entitled_to_registration(Person) :-
    fact(Person, section21_born_in_foreign_country, true),
    fact(Person, section21_birth_within_five_years_after_commencement, true),
    fact(Person, registration_application, true),
    fact(Person, section21_application_within_twelve_months_of_birth, true),
    fact(Person, section21_adapted_section9_father_requirements_met_for_bdt_citizenship, true),
    fact(Person, section21_would_become_bdt_under_section23_1_b_at_commencement, true).
