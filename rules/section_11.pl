:- use_module(library(scasp)).
:- use_module('../facts/facts.pl').

% Section 11(1): a CUKC with the pre-commencement right of abode is within the commencement rule.
section11_general_commencement_qualification(Person) :-
    fact(Person, section11_cukc_immediately_before_commencement, true),
    fact(Person, section11_right_of_abode_immediately_before_commencement, true).

% Section 11(2): the maternal stateless-registration exception is identified as a distinct higher-priority case.
section11_priority(s11_maternal_stateless_exception, 20).

% Section 11(1): the ordinary commencement rule has lower priority than subsection (2)'s exception.
section11_priority(s11_ordinary_commencement_rule, 10).

% Sections 11(1)-(2): numeric priority makes the subsection (2) condition control the ordinary rule.
section11_higher_priority(HigherRule, LowerRule) :-
    section11_priority(HigherRule, HigherRank),
    section11_priority(LowerRule, LowerRank),
    HigherRank > LowerRank.

% Section 11(2): the maternal stateless-registration exception is an input identifying the specified historic ground.
section11_maternal_stateless_exception(Person) :-
    fact(Person, section11_registered_under_1964_stateless_act_on_maternal_ground, true).

% Section 11(2)(a): the exception is satisfied if the mother becomes British at commencement or would but for death.
section11_maternal_exception_satisfied(Person) :-
    fact(Person, section11_mother_becomes_british_or_would_but_for_death, true).

% Section 11(2)(b): the alternative exception condition is the specified right of abode through settlement and residence.
section11_maternal_exception_satisfied(Person) :-
    fact(Person, section11_right_of_abode_under_immigration_act_2_1_c, true).

% Section 11(1)-(2): the ordinary commencement result applies when the special maternal restriction is not triggered.
section11_becomes_british_citizen(Person) :-
    section11_general_commencement_qualification(Person),
    not section11_maternal_stateless_exception(Person),
    section11_higher_priority(s11_maternal_stateless_exception, s11_ordinary_commencement_rule).

% Section 11(2): a person in the maternal exception qualifies if either specified subsection (2) condition is met.
section11_becomes_british_citizen(Person) :-
    section11_general_commencement_qualification(Person),
    section11_maternal_stateless_exception(Person),
    section11_maternal_exception_satisfied(Person),
    section11_higher_priority(s11_maternal_stateless_exception, s11_ordinary_commencement_rule).

% Section 11(3): the independent High Commissioner registration/descent conditions are represented as an external determination.
section11_becomes_british_citizen(Person) :-
    fact(Person, section11_high_commissioner_male_line_qualification, true).
