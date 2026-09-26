:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

:- discontiguous section15_rule_candidate/4.
:- discontiguous section15_rule_priority/3.
:- discontiguous section15_rule_conflict/3.
:- discontiguous section15_entitled_to_registration/1.

% Section 15(2): a found abandoned new-born supplies a presumed-parent candidate.
section15_rule_candidate(Person, section15_abandonment, presumed_qualifying_parent, s15_abandonment_presumption) :-
    fact(Person, section15_newborn_found_abandoned_in_dependent_territory, true),
    fact(Person, after_commencement, true).

% Section 15(2): contrary evidence supplies an opposing conclusion that the presumption is rebutted.
section15_rule_candidate(Person, section15_abandonment, presumption_rebutted, s15_contrary_evidence) :-
    fact(Person, section15_newborn_found_abandoned_in_dependent_territory, true),
    fact(Person, after_commencement, true),
    fact(Person, section15_parentage_contrary_shown, true).

% Section 15(2): contrary evidence has priority over the abandoned-infant presumption.
section15_rule_priority(section15_abandonment, s15_contrary_evidence, 20).

% Section 15(2): the abandoned-infant presumption has lower priority than contrary evidence.
section15_rule_priority(section15_abandonment, s15_abandonment_presumption, 10).

% Section 15(2): presumed parentage and rebuttal are incompatible conclusions.
section15_rule_conflict(section15_abandonment, presumed_qualifying_parent, presumption_rebutted).

% Section 15(2): expose the winning contrary-evidence outcome.
section15_abandonment_presumption_defeated(Person) :-
    section15_accepted_outcome(Person, section15_abandonment, presumption_rebutted).

% Section 15(1): a parent who is a BDT citizen at birth qualifies.
section15_parent_qualified_at_birth(Person) :-
    fact(Person, section15_parent_bdt_citizen_at_birth, true).

% Section 15(1): a parent settled in the territory of birth at the time of birth qualifies.
section15_parent_qualified_at_birth(Person) :-
    fact(Person, section15_parent_settled_in_birth_territory_at_birth, true).

% Section 15(2): deemed parentage is accepted only after resolving the competing contrary-evidence candidate.
section15_parent_qualified_at_birth(Person) :-
    section15_accepted_outcome(Person, section15_abandonment, presumed_qualifying_parent).

% Section 15(1)-(2): birth in a dependent territory and a qualifying parent confer citizenship.
section15_acquires_bdt_citizenship(Person) :-
    fact(Person, born_in_dependent_territory, true),
    fact(Person, after_commencement, true),
    section15_parent_qualified_at_birth(Person).

% Section 15(2): a new-born found abandoned there is deemed born there after commencement.
section15_acquires_bdt_citizenship(Person) :-
    section15_accepted_outcome(Person, section15_abandonment, presumed_qualifying_parent).

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

% Section 15(4): meeting the annual absence limit supplies a candidate that the requirement is satisfied.
section15_rule_candidate(Person, section15_absence, absence_requirement_met, s15_ordinary_absence_test) :-
    fact(Person, section15_each_first_ten_years_absence_at_most_90_days, true).

% Section 15(4): exceeding the annual absence limit supplies an opposing candidate that the requirement is not satisfied.
section15_rule_candidate(Person, section15_absence, absence_requirement_not_met, s15_ordinary_absence_test) :-
    fact(Person, section15_each_first_ten_years_absence_at_most_90_days, false).

% Section 15(7): special circumstances supply a higher-priority candidate that treats the absence requirement as satisfied.
section15_rule_candidate(Person, section15_absence, absence_requirement_met, s15_special_absence_relief) :-
    fact(Person, section15_secretary_approves_special_absence_relief, true).

% Section 15(7): special-circumstances relief has priority over the ordinary failed-absence-test candidate.
section15_rule_priority(section15_absence, s15_special_absence_relief, 20).

% Section 15(4): the ordinary absence test has lower priority than subsection (7) relief.
section15_rule_priority(section15_absence, s15_ordinary_absence_test, 10).

% Section 15(4), (7): satisfying and failing the absence requirement are incompatible conclusions.
section15_rule_conflict(section15_absence, absence_requirement_met, absence_requirement_not_met).

% Section 15(4), (7): registration is available when the ordinary or relieved absence conclusion is accepted.
section15_entitled_to_registration(Person) :-
    fact(Person, born_in_dependent_territory, true),
    fact(Person, after_commencement, true),
    fact(Person, section15_not_citizen_under_subsections_1_2, true),
    fact(Person, section15_application_after_tenth_birthday, true),
    section15_accepted_outcome(Person, section15_absence, absence_requirement_met).

% Section 15(6): annulment or other cessation of the adoption order does not end citizenship acquired under subsection (5).
section15_retains_bdt_citizenship_after_adoption_order_cessation(Person) :-
    fact(Person, section15_became_bdt_citizen_under_subsection_5, true),
    fact(Person, section15_adoption_order_ceased_to_have_effect, true).

% Section 15(2), (4), (7): an applicable incompatible higher-ranked candidate defeats the lower-ranked rule.
section15_rule_defeats(Person, Section, LowerRule, HigherRule) :-
    section15_rule_candidate(Person, Section, LowerOutcome, LowerRule),
    section15_rule_candidate(Person, Section, HigherOutcome, HigherRule),
    section15_rule_conflicts(Section, LowerOutcome, HigherOutcome),
    section15_rule_priority(Section, LowerRule, LowerRank),
    section15_rule_priority(Section, HigherRule, HigherRank),
    HigherRank > LowerRank.

% Section 15(2), (4), (7): conflicts apply in either candidate ordering.
section15_rule_conflicts(Section, Outcome, OtherOutcome) :-
    section15_rule_conflict(Section, Outcome, OtherOutcome).
section15_rule_conflicts(Section, Outcome, OtherOutcome) :-
    section15_rule_conflict(Section, OtherOutcome, Outcome).

% Section 15(2), (4), (7): record a candidate only when an applicable priority defeat exists.
section15_rule_defeated(Person, Section, Rule) :-
    section15_rule_defeats(Person, Section, Rule, _HigherRule).

% Section 15(2), (4), (7): accept an outcome only after rejecting defeated rules.
section15_accepted_outcome(Person, Section, Outcome) :-
    section15_rule_candidate(Person, Section, Outcome, Rule),
    not section15_rule_defeated(Person, Section, Rule).
