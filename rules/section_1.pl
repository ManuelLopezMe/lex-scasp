:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

:- discontiguous section1_rule_candidate/4.
:- discontiguous section1_rule_priority/3.
:- discontiguous section1_rule_conflict/3.

% Section 1(2): an unrebutted abandoned-infant presumption supplies a defeasible candidate conclusion.
section1_rule_candidate(Person, section1_abandonment, presumed_qualifying_parent, s1_abandonment_presumption) :-
    fact(Person, found_abandoned_in_uk, true),
    fact(Person, after_commencement, true).

% Section 1(2): contrary evidence supplies a competing conclusion that the presumption is rebutted.
section1_rule_candidate(Person, section1_abandonment, presumption_rebutted, s1_contrary_evidence) :-
    fact(Person, found_abandoned_in_uk, true),
    fact(Person, after_commencement, true),
    fact(Person, contrary_evidence_to_abandonment_presumption, true).

% Section 1(2): contrary evidence has priority over the abandoned-infant presumption.
section1_rule_priority(section1_abandonment, s1_contrary_evidence, 20).

% Section 1(2): the abandoned-infant presumption has lower priority than contrary evidence.
section1_rule_priority(section1_abandonment, s1_abandonment_presumption, 10).

% Section 1(2): the presumption and contrary evidence are incompatible conclusions.
section1_rule_conflict(section1_abandonment, presumed_qualifying_parent, presumption_rebutted).

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

% Section 1(2): the presumption is accepted only if no higher-priority contrary-evidence candidate defeats it.
section1_abandoned_infant_qualifies(Person) :-
    section1_accepted_outcome(Person, section1_abandonment, presumed_qualifying_parent).

% Section 1(2): contrary evidence defeats the abandonment presumption when both candidates apply.
section1_abandonment_presumption_defeated(Person) :-
    section1_accepted_outcome(Person, section1_abandonment, presumption_rebutted).

% Section 1(1)-(2): citizenship under the birth and abandonment provisions is British citizenship.
section1_citizen_under_subsections_1_2(Person) :-
    section1_birth_with_qualifying_parent(Person).

% Section 1(2): an unrebutted abandoned-infant presumption establishes citizenship under subsection (2).
section1_citizen_under_subsections_1_2(Person) :-
    section1_abandoned_infant_qualifies(Person).

% Section 1(3): a parent who becomes a British citizen during the person's minority qualifies.
section1_parent_became_qualifying(Person) :-
    fact(Person, parent_became_qualifying, true).

% Section 1(3): the registration route is a candidate even when birth citizenship also applies.
section1_minor_registration_candidate(Person) :-
    fact(Person, born_in_uk, true),
    fact(Person, after_commencement, true),
    fact(Person, minor_at_application, true),
    fact(Person, registration_application, true),
    section1_parent_became_qualifying(Person).

% Section 1(4): the ordinary registration route is a candidate alongside any subsection (1)-(2) birth status.
section1_ten_year_registration_candidate(Person) :-
    fact(Person, born_in_uk, true),
    fact(Person, after_commencement, true),
    fact(Person, age_at_application, Age),
    Age >= 10,
    fact(Person, registration_application, true),
    fact(Person, first_ten_years_absence_within_90_days_each_year, true).

% Section 1(7): special-circumstances relief is an alternative candidate for the subsection (4) registration route.
section1_ten_year_registration_candidate(Person) :-
    fact(Person, born_in_uk, true),
    fact(Person, after_commencement, true),
    fact(Person, age_at_application, Age),
    Age >= 10,
    fact(Person, registration_application, true),
    fact(Person, secretary_of_state_special_circumstances, true).

% Sections 1(1)-(2): established birth citizenship and later registration entitlement are competing status conclusions.
section1_rule_candidate(Person, section1_registration, already_citizen, s1_birth_status) :-
    section1_citizen_under_subsections_1_2(Person).

% Section 1(3): a minor-registration applicant is a candidate for registration entitlement.
section1_rule_candidate(Person, section1_registration, registration_entitlement, s1_minor_registration) :-
    section1_minor_registration_candidate(Person).

% Section 1(4), (7): the ordinary or special-circumstances ten-year route is a registration-entitlement candidate.
section1_rule_candidate(Person, section1_registration, registration_entitlement, s1_ten_year_registration) :-
    section1_ten_year_registration_candidate(Person).

% Section 1(3): birth citizenship has priority over the conflicting minor-registration entitlement.
section1_rule_priority(section1_registration, s1_birth_status, 30).

% Section 1(3)-(4): registration entitlement has lower priority than established birth citizenship.
section1_rule_priority(section1_registration, s1_minor_registration, 10).

% Section 1(4): ten-year registration entitlement has lower priority than established birth citizenship.
section1_rule_priority(section1_registration, s1_ten_year_registration, 10).

% Section 1(3)-(4): birth citizenship and registration entitlement cannot both be the governing status conclusion.
section1_rule_conflict(section1_registration, already_citizen, registration_entitlement).

% Section 1(3): entitlement is accepted only after resolving any conflicting birth-citizenship candidate.
section1_minor_registration_entitled(Person) :-
    section1_accepted_outcome(Person, section1_registration, registration_entitlement),
    section1_minor_registration_candidate(Person).

% Section 1(4), (7): entitlement is accepted only after resolving any conflicting birth-citizenship candidate.
section1_ten_year_registration_entitled(Person) :-
    section1_accepted_outcome(Person, section1_registration, registration_entitlement),
    section1_ten_year_registration_candidate(Person).

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

% Sections 1(2)-(4), (7): an applicable incompatible higher-ranked candidate defeats a lower-ranked rule.
section1_rule_defeats(Person, Section, LowerRule, HigherRule) :-
    section1_rule_candidate(Person, Section, LowerOutcome, LowerRule),
    section1_rule_candidate(Person, Section, HigherOutcome, HigherRule),
    section1_rule_conflicts(Section, LowerOutcome, HigherOutcome),
    section1_rule_priority(Section, LowerRule, LowerRank),
    section1_rule_priority(Section, HigherRule, HigherRank),
    HigherRank > LowerRank.

% Sections 1(2)-(4), (7): conflicts apply in either candidate ordering.
section1_rule_conflicts(Section, Outcome, OtherOutcome) :-
    section1_rule_conflict(Section, Outcome, OtherOutcome).
section1_rule_conflicts(Section, Outcome, OtherOutcome) :-
    section1_rule_conflict(Section, OtherOutcome, Outcome).

% Sections 1(2)-(4), (7): record a rule only when an applicable priority defeat exists.
section1_rule_defeated(Person, Section, Rule) :-
    section1_rule_defeats(Person, Section, Rule, _HigherRule).

% Sections 1(2)-(4), (7): accept a candidate only after rejecting defeated rules.
section1_accepted_outcome(Person, Section, Outcome) :-
    section1_rule_candidate(Person, Section, Outcome, Rule),
    not section1_rule_defeated(Person, Section, Rule).
