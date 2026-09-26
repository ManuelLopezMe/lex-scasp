:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

:- discontiguous section11_becomes_british_citizen/1.
% Section 11(1): a CUKC with the pre-commencement right of abode is within the commencement rule.
section11_general_commencement_qualification(Person) :-
    fact(Person, section11_cukc_immediately_before_commencement, true),
    fact(Person, section11_right_of_abode_immediately_before_commencement, true).

% Section 11(2): the maternal stateless-registration exception is an input identifying the specified historic ground.
section11_maternal_stateless_exception(Person) :-
    fact(Person, section11_registered_under_1964_stateless_act_on_maternal_ground, true).

% Section 11(2)(a): the exception is satisfied if the mother becomes British at commencement or would but for death.
section11_maternal_exception_satisfied(Person) :-
    fact(Person, section11_mother_becomes_british_or_would_but_for_death, true).

% Section 11(2)(b): the alternative exception condition is the specified right of abode through settlement and residence.
section11_maternal_exception_satisfied(Person) :-
    fact(Person, section11_right_of_abode_under_immigration_act_2_1_c, true).

% Section 11(1): the ordinary CUKC/right-of-abode route supplies a citizenship candidate even when subsection (2) also applies.
section11_rule_candidate(Person, section11, becomes_british_citizen, s11_ordinary_commencement_rule) :-
    section11_general_commencement_qualification(Person).

% Section 11(2): the maternal stateless ground denies the ordinary route when neither statutory alternative is satisfied.
section11_rule_candidate(Person, section11, does_not_become_british_citizen, s11_maternal_stateless_exception) :-
    section11_general_commencement_qualification(Person),
    section11_maternal_stateless_exception(Person),
    fact(Person, section11_mother_becomes_british_or_would_but_for_death, false),
    fact(Person, section11_right_of_abode_under_immigration_act_2_1_c, false).

% Section 11(1)-(2): a higher-priority maternal exception defeats the ordinary citizenship candidate.
section11_rule_priority(section11, s11_maternal_stateless_exception, 20).

% Section 11(1): the ordinary commencement route has lower priority than the maternal exception.
section11_rule_priority(section11, s11_ordinary_commencement_rule, 10).

% Section 11(1)-(2): becoming and not becoming a British citizen are incompatible outcomes.
section11_rule_conflict(section11, becomes_british_citizen, does_not_become_british_citizen).

% Section 11(1): accept citizenship when no higher-priority contradictory exception defeats it.
section11_becomes_british_citizen(Person) :-
    section11_accepted_outcome(Person, section11, becomes_british_citizen).

% Section 11(2): report the outcome selected by the higher-priority maternal exception.
section11_does_not_become_british_citizen(Person) :-
    section11_accepted_outcome(Person, section11, does_not_become_british_citizen).

% Section 11(3): the independent High Commissioner registration/descent conditions are represented as an external determination.
section11_becomes_british_citizen(Person) :-
    fact(Person, section11_high_commissioner_male_line_qualification, true).

% Section 11(1)-(2): the applicable maternal exception defeats the lower-ranked commencement candidate.
section11_rule_defeats(Person, Section, LowerRule, HigherRule) :-
    section11_rule_candidate(Person, Section, LowerOutcome, LowerRule),
    section11_rule_candidate(Person, Section, HigherOutcome, HigherRule),
    section11_rule_conflicts(Section, LowerOutcome, HigherOutcome),
    section11_rule_priority(Section, LowerRule, LowerRank),
    section11_rule_priority(Section, HigherRule, HigherRank),
    HigherRank > LowerRank.

% Section 11(1)-(2): conflicts apply in either candidate ordering.
section11_rule_conflicts(Section, Outcome, OtherOutcome) :-
    section11_rule_conflict(Section, Outcome, OtherOutcome).
section11_rule_conflicts(Section, Outcome, OtherOutcome) :-
    section11_rule_conflict(Section, OtherOutcome, Outcome).

% Section 11(1)-(2): record a candidate only when an applicable priority defeat exists.
section11_rule_defeated(Person, Section, Rule) :-
    section11_rule_defeats(Person, Section, Rule, _HigherRule).

% Section 11(1)-(2): accept a citizenship outcome only after rejecting defeated rules.
section11_accepted_outcome(Person, Section, Outcome) :-
    section11_rule_candidate(Person, Section, Outcome, Rule),
    not section11_rule_defeated(Person, Section, Rule).
