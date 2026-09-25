:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

% Section 15(2): contrary evidence has priority over the abandoned-infant presumption.
section15_priority(s15_contrary_evidence, 20).

% Section 15(2): the abandoned-infant presumption has lower priority than contrary evidence.
section15_priority(s15_abandonment_presumption, 10).

% Section 15(4), (7): the special-circumstances decision has priority to relax the ten-year absence test.
section15_priority(s15_special_absence_relief, 20).

% Section 15(4): the ordinary first-ten-years absence test has lower priority than subsection (7) relief.
section15_priority(s15_ten_year_absence_test, 10).

% Section 15(2), (4), (7): numeric priority records the statutory precedence of contrary evidence and special-circumstances relief.
section15_higher_priority(HigherRule, LowerRule) :-
    section15_priority(HigherRule, HigherRank),
    section15_priority(LowerRule, LowerRank),
    HigherRank > LowerRank.

% Section 15(2): express contrary evidence defeats the lower-priority abandoned-infant presumption.
section15_abandonment_presumption_defeated(Person) :-
    fact(Person, section15_newborn_found_abandoned_in_dependent_territory, true),
    fact(Person, section15_parentage_contrary_shown, true),
    section15_higher_priority(s15_contrary_evidence, s15_abandonment_presumption).

% Section 15(1): a parent who is a BDT citizen at birth qualifies.
section15_parent_qualified_at_birth(Person) :-
    fact(Person, section15_parent_bdt_citizen_at_birth, true).

% Section 15(1): a parent settled in the territory of birth at the time of birth qualifies.
section15_parent_qualified_at_birth(Person) :-
    fact(Person, section15_parent_settled_in_birth_territory_at_birth, true).

% Section 15(2): a found abandoned new-born is deemed to have a qualifying parent only when contrary evidence is expressly absent.
section15_parent_qualified_at_birth(Person) :-
    fact(Person, section15_newborn_found_abandoned_in_dependent_territory, true),
    fact(Person, section15_parentage_contrary_shown, false),
    section15_higher_priority(s15_contrary_evidence, s15_abandonment_presumption).

% Section 15(1)-(2): birth in a dependent territory and a qualifying parent confer citizenship.
section15_acquires_bdt_citizenship(Person) :-
    fact(Person, born_in_dependent_territory, true),
    fact(Person, after_commencement, true),
    section15_parent_qualified_at_birth(Person).

% Section 15(2): a new-born found abandoned there is deemed born there after commencement.
section15_acquires_bdt_citizenship(Person) :-
    fact(Person, section15_newborn_found_abandoned_in_dependent_territory, true),
    fact(Person, section15_parentage_contrary_shown, false),
    section15_higher_priority(s15_contrary_evidence, s15_abandonment_presumption).

% Section 15(5): adoption by a BDT citizen makes the non-citizen minor a citizen when the order is made.
section15_acquires_bdt_citizenship(Person) :-
    fact(Person, section15_adoptee_not_bdt_citizen_before_order, true),
    fact(Person, section15_adoption_order_made_by_dependent_territory_court, true),
    fact(Person, section15_adopter_bdt_citizen_on_order_date, true).

% Section 15(3): an otherwise non-citizen child born there is entitled when a parent becomes a citizen while the child is a minor and an application is made.
section15_entitled_to_registration(Person) :-
    fact(Person, born_in_dependent_territory, true),
    fact(Person, after_commencement, true),
    fact(Person, section15_not_citizen_under_subsections_1_2, true),
    fact(Person, section15_parent_becomes_bdt_citizen_while_minor, true),
    fact(Person, section15_application_while_minor, true).

% Section 15(3): an otherwise non-citizen child born there is entitled when a parent becomes settled there while the child is a minor and an application is made.
section15_entitled_to_registration(Person) :-
    fact(Person, born_in_dependent_territory, true),
    fact(Person, after_commencement, true),
    fact(Person, section15_not_citizen_under_subsections_1_2, true),
    fact(Person, section15_parent_becomes_settled_in_dependent_territory_while_minor, true),
    fact(Person, section15_application_while_minor, true).

% Section 15(4): a person aged at least ten is entitled on application if each of the first ten years meets the 90-day limit.
section15_entitled_to_registration(Person) :-
    fact(Person, born_in_dependent_territory, true),
    fact(Person, after_commencement, true),
    fact(Person, section15_not_citizen_under_subsections_1_2, true),
    fact(Person, section15_application_after_tenth_birthday, true),
    fact(Person, section15_each_first_ten_years_absence_at_most_90_days, true),
    section15_higher_priority(s15_special_absence_relief, s15_ten_year_absence_test).

% Section 15(4), (7): the Secretary of State may waive excess absence in special circumstances.
section15_entitled_to_registration(Person) :-
    fact(Person, born_in_dependent_territory, true),
    fact(Person, after_commencement, true),
    fact(Person, section15_not_citizen_under_subsections_1_2, true),
    fact(Person, section15_application_after_tenth_birthday, true),
    fact(Person, section15_secretary_approves_special_absence_relief, true),
    section15_higher_priority(s15_special_absence_relief, s15_ten_year_absence_test).

% Section 15(6): annulment or other cessation of the adoption order does not end citizenship acquired under subsection (5).
section15_retains_bdt_citizenship_after_adoption_order_cessation(Person) :-
    fact(Person, section15_became_bdt_citizen_under_subsection_5, true),
    fact(Person, section15_adoption_order_ceased_to_have_effect, true).
