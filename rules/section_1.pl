:- use_module(library(scasp)).
:- use_module('../facts/rdf_facts.pl').

% Section 1(2): contrary evidence has precedence over the abandoned-infant presumption.
section1_priority(s1_contrary_evidence, 20).

% Section 1(2): the abandoned-infant presumption applies below contrary evidence.
section1_priority(s1_abandonment_presumption, 10).

% Section 1(3): birth citizenship takes precedence over minor-registration entitlement.
section1_priority(s1_birth_status, 30).

% Section 1(3): minor-registration entitlement is lower priority than birth citizenship.
section1_priority(s1_minor_registration, 10).

% Section 1(4): birth citizenship takes precedence over ten-year registration entitlement.
section1_priority(s1_ten_year_registration, 10).

% Section 1(7): special-circumstances discretion takes precedence over the ordinary absence limit.
section1_priority(s1_special_circumstances, 20).

% Sections 1(2)-(4): a higher numeric rank takes priority over a lower-ranked rule.
section1_higher_priority(HigherRule, LowerRule) :-
    section1_priority(HigherRule, HigherRank),
    section1_priority(LowerRule, LowerRank),
    HigherRank > LowerRank.

% Section 1(1): either a British-citizen parent or a settled parent qualifies.
section1_parent_qualifies(Person) :-
    fact(Person, parent_is_citizen, true).

% Section 1(1): a parent settled in the United Kingdom also qualifies.
section1_parent_qualifies(Person) :-
    fact(Person, parent_is_settled, true).

% Section 1(1): the person must have been born in the UK after commencement to a qualifying parent.
section1_birth_with_qualifying_parent(Person) :-
    fact(Person, born_in_uk, true),
    fact(Person, after_commencement, true),
    section1_parent_qualifies(Person).

% Section 1(2): a new-born infant found abandoned in the UK is presumed to have
% been born there after commencement to a qualifying parent unless rebutted.
section1_abandoned_infant_qualifies(Person) :-
    fact(Person, found_abandoned_in_uk, true),
    fact(Person, after_commencement, true),
    not fact(Person, contrary_evidence_to_abandonment_presumption, true),
    section1_higher_priority(s1_contrary_evidence, s1_abandonment_presumption).

% Section 1(1)-(2): citizenship under the birth and abandonment provisions is British citizenship.
section1_citizen_under_subsections_1_2(Person) :-
    section1_birth_with_qualifying_parent(Person).

% Section 1(2): an unrebutted abandoned-infant presumption establishes citizenship under subsection (2).
section1_citizen_under_subsections_1_2(Person) :-
    section1_abandoned_infant_qualifies(Person).

% Section 1(3): a parent who becomes a British citizen during the person's minority qualifies.
section1_parent_became_qualifying(Person) :-
    fact(Person, parent_became_qualifying, true).

% Section 1(3): an application while a minor entitles a UK-born person to
% registration if a parent becomes a citizen or settled and subsections (1)-(2)
% do not already confer citizenship.
section1_minor_registration_entitled(Person) :-
    fact(Person, born_in_uk, true),
    fact(Person, after_commencement, true),
    fact(Person, minor_at_application, true),
    fact(Person, registration_application, true),
    section1_parent_became_qualifying(Person),
    not section1_citizen_under_subsections_1_2(Person),
    section1_higher_priority(s1_birth_status, s1_minor_registration).

% Section 1(4): an application after age ten qualifies when absence in each of
% the first ten years did not exceed 90 days and subsections (1)-(2) do not apply.
section1_ten_year_registration_entitled(Person) :-
    fact(Person, born_in_uk, true),
    fact(Person, after_commencement, true),
    fact(Person, age_at_application, Age),
    Age >= 10,
    fact(Person, registration_application, true),
    fact(Person, first_ten_years_absence_within_90_days_each_year, true),
    not section1_citizen_under_subsections_1_2(Person),
    section1_higher_priority(s1_birth_status, s1_ten_year_registration).

% Section 1(7): special circumstances allow subsection (4)'s absence requirement
% to be treated as satisfied despite excess absences.
section1_ten_year_registration_entitled(Person) :-
    fact(Person, born_in_uk, true),
    fact(Person, after_commencement, true),
    fact(Person, age_at_application, Age),
    Age >= 10,
    fact(Person, registration_application, true),
    fact(Person, secretary_of_state_special_circumstances, true),
    not section1_citizen_under_subsections_1_2(Person),
    section1_higher_priority(s1_special_circumstances, s1_ten_year_registration).

% Section 1(5): a UK-court adoption order makes a minor a citizen if an adopter
% is British on the date of the order.
section1_adoption_citizen(Person) :-
    fact(Person, uk_court_adoption_order, true),
    fact(Person, adopter_is_british_citizen_on_order_date, true).

% Section 1(6): citizenship acquired through adoption continues if the order ceases to have effect.
section1_adoption_status_retained(Person) :-
    section1_adoption_citizen(Person),
    fact(Person, adoption_order_ceased, true).

% Section 1(1)-(2): citizenship under the birth provisions is British citizenship.
section1_british_citizen(Person) :-
    section1_citizen_under_subsections_1_2(Person).

% Section 1(5): citizenship acquired under the adoption provision is British citizenship.
section1_british_citizen(Person) :-
    section1_adoption_citizen(Person).

% Section 1(6): cessation of the adoption order does not remove British citizenship.
section1_british_citizen(Person) :-
    section1_adoption_status_retained(Person).
