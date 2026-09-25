:- module(bna_rdf_facts, [fact/3, relation/3, example_triple/3]).

:- use_module(library(semweb/rdf_db)).

bna_namespace('https://example.org/bna#').

:- dynamic fact/3.
:- dynamic relation/3.

% Each record expands to seven RDF triples in the RDF store.
example_triple(Subject, Predicate, literal(DateOfBirth)) :-
    example_individual(Id, DateOfBirth, _, _, _, _, _, _),
    example_subject(Id, Subject),
    example_predicate(dateOfBirth, Predicate).
example_triple(Subject, Predicate, literal(PlaceOfBirth)) :-
    example_individual(Id, _, PlaceOfBirth, _, _, _, _, _),
    example_subject(Id, Subject),
    example_predicate(placeOfBirth, Predicate).
example_triple(Subject, Predicate, literal(Parent1Citizenship)) :-
    example_individual(Id, _, _, Parent1Citizenship, _, _, _, _),
    example_subject(Id, Subject),
    example_predicate(parent1_citizenship, Predicate).
example_triple(Subject, Predicate, literal(Parent1Status)) :-
    example_individual(Id, _, _, _, Parent1Status, _, _, _),
    example_subject(Id, Subject),
    example_predicate(parent1_status, Predicate).
example_triple(Subject, Predicate, literal(Parent2Citizenship)) :-
    example_individual(Id, _, _, _, _, Parent2Citizenship, _, _),
    example_subject(Id, Subject),
    example_predicate(parent2_citizenship, Predicate).
example_triple(Subject, Predicate, literal(Parent2Status)) :-
    example_individual(Id, _, _, _, _, _, Parent2Status, _),
    example_subject(Id, Subject),
    example_predicate(parent2_status, Predicate).
example_triple(Subject, Predicate, literal(ResidencyHistory)) :-
    example_individual(Id, _, _, _, _, _, _, ResidencyHistory),
    example_subject(Id, Subject),
    example_predicate(residencyHistory, Predicate).

example_subject(Id, Subject) :-
    bna_namespace(Namespace),
    atom_concat(Namespace, Id, Subject).

example_predicate(Name, Predicate) :-
    bna_namespace(Namespace),
    atom_concat(Namespace, Name, Predicate).

load_example_triples :-
    forall(example_triple(Subject, Predicate, Object),
           ( rdf_assert(Subject, Predicate, Object, bna_examples),
             cache_source_fact(Subject, Predicate, Object)
           )),
    forall(example_individual(Id, _, _, _, _, _, _, _),
           derive_individual_facts(Id)).

:- initialization(load_example_triples).

cache_source_fact(Subject, Predicate, Literal) :-
    bna_namespace(Namespace),
    atom_concat(Namespace, Property, Predicate),
    literal_value(Literal, Value),
    assertz(fact(Subject, Property, Value)).

derive_individual_facts(Id) :-
    example_subject(Id, Person),
    fact(Person, placeOfBirth, Place),
    (   Place == 'United Kingdom'
    ->  assertz(fact(Person, born_in_uk, true))
    ;   assertz(fact(Person, born_outside_uk, true))
    ),
    fact(Person, dateOfBirth, Date),
    (   Date @>= '1983-01-01'
    ->  assertz(fact(Person, after_commencement, true))
    ;   true
    ),
    derive_parent_facts(Person, parent1_citizenship, parent1_status),
    derive_parent_facts(Person, parent2_citizenship, parent2_status),
    derive_residency_facts(Person).

derive_parent_facts(Person, CitizenshipProperty, StatusProperty) :-
    fact(Person, CitizenshipProperty, Citizenship),
    fact(Person, StatusProperty, Status),
    downcase_atom(Citizenship, CitizenshipText),
    downcase_atom(Status, StatusText),
    (   sub_atom(CitizenshipText, _, _, _, 'british citizen')
    ->  assertz(fact(Person, parent_is_citizen, true))
    ;   true
    ),
    (   sub_atom(CitizenshipText, _, _, _, 'british citizen'),
        sub_atom(StatusText, _, _, _, 'adopter')
    ->  assertz(fact(Person, adopter_is_british_citizen_on_order_date, true))
    ;   true
    ),
    (   sub_atom(StatusText, _, _, _, 'settled in the uk')
    ->  assertz(fact(Person, parent_is_settled, true))
    ;   true
    ),
    (   sub_atom(StatusText, _, _, _, 'otherwise than by descent')
    ->  assertz(fact(Person, parent_is_citizen_otherwise_than_descent, true))
    ;   true
    ),
    (   sub_atom(CitizenshipText, _, _, _, 'british citizen'),
        sub_atom(StatusText, _, _, _, 'crown service'),
        sub_atom(StatusText, _, _, _, 'recruited in uk')
    ->  assertz(fact(Person, parent_has_qualifying_service, true))
    ;   true
    ),
    (   sub_atom(CitizenshipText, _, _, _, 'british citizen'),
        sub_atom(StatusText, _, _, _, 'designated service'),
        sub_atom(StatusText, _, _, _, 'recruited in uk')
    ->  assertz(fact(Person, parent_has_qualifying_service, true))
    ;   true
    ),
    (   sub_atom(CitizenshipText, _, _, _, 'british citizen'),
        sub_atom(StatusText, _, _, _, 'community service'),
        sub_atom(StatusText, _, _, _, 'recruited in member state')
    ->  assertz(fact(Person, parent_has_community_service, true))
    ;   true
    ),
    (   sub_atom(StatusText, _, _, _, 'by descent')
    ->  assertz(fact(Person, parent_is_citizen_by_descent, true))
    ;   true
    ),
    (   sub_atom(StatusText, _, _, _, 'qualifying grandparent')
    ->  assertz(fact(Person, parent_has_qualifying_grandparent, true))
    ;   true
    ),
    (   sub_atom(StatusText, _, _, _, 'by descent'),
        sub_atom(StatusText, _, _, _, 'qualifying grandparent')
    ->  assertz(fact(Person, section3_parent_ancestry_qualified, true))
    ;   true
    ),
    (   contains_any(StatusText, ['later settled', 'later naturalised'])
    ->  assertz(fact(Person, parent_became_qualifying, true))
    ;   true
    ).
derive_parent_facts(Person, CitizenshipProperty, StatusProperty) :-
    \+ fact(Person, CitizenshipProperty, _),
    \+ fact(Person, StatusProperty, _).

derive_residency_facts(Person) :-
    fact(Person, residencyHistory, History),
    downcase_atom(History, Text),
    (   sub_atom(Text, _, _, _, 'new-born found abandoned in uk')
    ->  assertz(fact(Person, found_abandoned_in_uk, true))
    ;   true
    ),
    (   sub_atom(Text, _, _, _, 'contrary evidence')
    ->  assertz(fact(Person, contrary_evidence_to_abandonment_presumption, true))
    ;   true
    ),
    (   sub_atom(Text, _, _, _, 'special circumstances')
    ->  assertz(fact(Person, secretary_of_state_special_circumstances, true))
    ;   true
    ),
    (   sub_atom(Text, _, _, _, 'uk court adoption order')
    ->  assertz(fact(Person, uk_court_adoption_order, true))
    ;   true
    ),
    (   sub_atom(Text, _, _, _, 'registration application'),
        sub_atom(Text, _, _, _, 'minor')
    ->  assertz(fact(Person, minor_at_application, true)),
        assertz(fact(Person, registration_application, true))
    ;   true
    ),
    (   application_months(Text, Months)
    ->  assertz(fact(Person, registration_application, true)),
        assertz(fact(Person, application_months_after_birth, Months))
    ;   true
    ),
    (   sub_atom(Text, _, _, _, 'application after 12 months'),
        sub_atom(Text, _, _, _, 'special circumstances')
    ->  assertz(fact(Person, registration_application, true)),
        assertz(fact(Person, application_months_after_birth, 24))
    ;   true
    ),
    (   sub_atom(Text, _, _, _, 'qualifying grandparent')
    ->  (   fact(Person, parent_is_citizen_by_descent, true)
        ->  assertz(fact(Person, section3_parent_ancestry_qualified, true))
        ;   true
        )
    ;   true
    ),
    (   contains_any(Text, ['uk at start', 'uk throughout'])
    ->  assertz(fact(Person, section3_parent_in_uk_at_start, true))
    ;   true
    ),
    (   section3_absence_days(Text, Days)
    ->  assertz(fact(Person, section3_parent_absence_days, Days))
    ;   true
    ),
    (   sub_atom(Text, _, _, _, '271 days absent')
    ->  assertz(fact(Person, section3_parent_absence_days, 271))
    ;   true
    ),
    (   sub_atom(Text, _, _, _, 'period ends before birth')
    ->  assertz(fact(Person, section3_period_ends_by_birth, true))
    ;   true
    ),
    (   sub_atom(Text, _, _, _, 'born stateless')
    ->  assertz(fact(Person, born_stateless, true))
    ;   assertz(fact(Person, born_stateless, false))
    ),
    (   sub_atom(Text, _, _, _, '90 days absent in each first year')
    ->  assertz(fact(Person, first_ten_years_absence_within_90_days_each_year, true))
    ;   true
    ),
    (   sub_atom(Text, _, _, _, '91 days absent')
    ->  assertz(fact(Person, first_ten_years_absence_within_90_days_each_year, false))
    ;   true
    ),
    (   sub_atom(Text, _, _, _, 'excess absence')
    ->  assertz(fact(Person, first_ten_years_absence_within_90_days_each_year, false))
    ;   true
    ),
    (   contains_any(Text, ['90 days absent in each first year',
                            '91 days absent', 'excess absence'])
    ->  assertz(fact(Person, age_at_application, 11)),
        assertz(fact(Person, registration_application, true))
    ;   true
    ),
    (   sub_atom(Text, _, _, _, 'contrary evidence about parentage')
    ->  assertz(fact(Person, contrary_evidence_to_abandonment_presumption, true))
    ;   true
    ).

application_months(Text, Months) :-
    member(Months, [5, 8, 11, 12, 13, 24]),
    number_string(Months, Number),
    format(string(Phrase), 'application at ~w months', [Number]),
    sub_string(Text, _, _, _, Phrase),
    !.
application_months(Text, 24) :-
    sub_atom(Text, _, _, _, 'application after 12 months'),
    sub_atom(Text, _, _, _, 'special circumstances').

contains_any(Text, [Needle|_]) :-
    sub_atom(Text, _, _, _, Needle),
    !.
contains_any(Text, [_|Rest]) :-
    contains_any(Text, Rest).

section3_absence_days(Text, Days) :-
    member(Days, [100, 200, 270, 271, 300]),
    number_string(Days, Number),
    format(string(Phrase), '~w days absent', [Number]),
    sub_string(Text, _, _, _, Phrase),
    !.

literal_value(literal(type(_, Lexical)), Value) :-
    lexical_string(Lexical, String),
    (   number_string(Value, String)
    ->  true
    ;   atom_string(Value, String)
    ).
literal_value(literal(Lexical), Value) :-
    lexical_string(Lexical, String),
    atom_string(Value, String).

lexical_string(Value, Value) :-
    string(Value),
    !.
lexical_string(Value, String) :-
    atom(Value),
    atom_string(Value, String).

% UK births: two positive examples with a British or settled parent.
example_individual(uk_birth_british_parent, '1985-01-14', 'United Kingdom',
                   'British citizen', 'otherwise than by descent',
                   'not British', 'not settled', 'UK throughout childhood').
example_individual(uk_birth_settled_parent, '1990-06-22', 'United Kingdom',
                   'not British', 'settled in the UK',
                   'not British', 'not settled', 'UK throughout childhood').

% Overseas births: two examples with a qualifying British parent.
example_individual(overseas_birth_parent_by_own_right, '1987-03-09', 'France',
                   'British citizen', 'otherwise than by descent',
                   'not British', 'not settled', 'resident abroad at birth').
example_individual(overseas_birth_mother_by_own_right, '1992-11-30', 'Canada',
                   'not British', 'not settled',
                   'British citizen', 'otherwise than by descent',
                   'resident abroad at birth').

% Descent/service routes and contrasting facts.
example_individual(descent_crown_service, '1984-02-17', 'Germany',
                   'British citizen', 'Crown service; recruited in UK',
                   'not British', 'not settled', 'parent serving abroad').
example_individual(descent_community_service, '1988-08-05', 'Belgium',
                   'British citizen', 'Community service; recruited in member state',
                   'not British', 'not settled', 'parent serving abroad').
example_individual(descent_parent_only_by_descent, '1991-04-12', 'Spain',
                   'British citizen', 'by descent only',
                   'not British', 'not settled', 'no qualifying service').
example_individual(descent_designated_service, '1994-10-01', 'Italy',
                   'British citizen', 'designated service; recruited in UK',
                   'not British', 'not settled', 'parent serving abroad').

% Section 1 edge cases: abandonment, rebuttal, adoption and registration.
example_individual(edge_abandoned_infant, '1983-01-01', 'United Kingdom',
                   'unknown', 'unknown', 'unknown', 'unknown',
                   'new-born found abandoned in UK').
example_individual(edge_abandonment_rebutted, '1983-01-02', 'United Kingdom',
                   'not British', 'not settled', 'unknown', 'unknown',
                   'new-born found abandoned in UK; contrary evidence about parentage').
example_individual(edge_parent_settles_during_minority, '2005-05-19',
                   'United Kingdom', 'not British', 'parent later settled',
                   'not British', 'not settled', 'registration application as minor').
example_individual(edge_parent_naturalises_during_minority, '2007-07-07',
                   'United Kingdom', 'not British', 'parent later naturalised',
                   'not British', 'not settled', 'registration application as minor').
example_individual(edge_ten_year_absence_at_limit, '2000-09-15',
                   'United Kingdom', 'not British', 'not settled',
                   'not British', 'not settled', '90 days absent in each first year').
example_individual(edge_ten_year_absence_over_limit, '2000-10-16',
                   'United Kingdom', 'not British', 'not settled',
                   'not British', 'not settled', '91 days absent in one early year; age 11').
example_individual(edge_special_absence_discretion, '1998-02-03',
                   'United Kingdom', 'not British', 'not settled',
                   'not British', 'not settled',
                   'excess absence; special circumstances; age 11').
example_individual(edge_adoption_uk_court_british_adopter, '2010-03-11',
                   'United Kingdom', 'British citizen', 'adopter',
                   'not British', 'joint adopter not British',
                   'UK court adoption order').
example_individual(edge_adoption_order_ceases, '2011-04-21',
                   'United Kingdom', 'British citizen', 'adopter',
                   'not British', 'not settled', 'adoption order later ceases').
example_individual(edge_adoption_nonbritish_adopter, '2012-05-31',
                   'United Kingdom', 'not British', 'adopter',
                   'not British', 'adopter', 'UK court adoption order').
example_individual(edge_born_before_commencement, '1982-12-31',
                   'United Kingdom', 'British citizen', 'otherwise than by descent',
                   'not British', 'not settled', 'before commencement').
example_individual(edge_uk_birth_no_qualifying_parent, '1995-12-12',
                   'United Kingdom', 'not British', 'not settled',
                   'not British', 'not settled', 'parents not settled').

% Section 2 edge cases: parent status, recruitment location and service type.
example_individual(edge_service_recruited_abroad, '1993-01-19', 'Kenya',
                   'British citizen', 'Crown service; recruited abroad',
                   'not British', 'not settled', 'parent serving outside UK').
example_individual(edge_service_not_designated, '1996-06-08', 'Japan',
                   'British citizen', 'service not designated',
                   'not British', 'not settled', 'parent serving outside UK').
example_individual(edge_community_recruited_nonmember, '1997-07-23', 'Norway',
                   'British citizen', 'Community service; recruited outside member state',
                   'not British', 'not settled', 'parent serving abroad').
example_individual(edge_community_not_institution, '1999-08-14', 'Austria',
                   'British citizen', 'not serving a Community institution',
                   'not British', 'not settled', 'parent serving abroad').
example_individual(edge_overseas_parent_settled_only, '2001-09-25', 'Portugal',
                   'not British', 'settled only',
                   'not British', 'not settled', 'no British parent').
example_individual(edge_overseas_both_parents_qualifying, '2002-10-06',
                   'Netherlands', 'British citizen', 'otherwise than by descent',
                   'British citizen', 'otherwise than by descent',
                   'both parents qualify').
example_individual(edge_overseas_parent_by_descent_service, '2003-11-17',
                   'Greece', 'British citizen', 'by descent; Crown service',
                   'not British', 'not settled', 'recruited in UK').
example_individual(edge_overseas_no_qualifying_parent, '2004-12-28', 'Turkey',
                   'not British', 'not settled', 'not British', 'not settled',
                   'no qualifying service').

% Section 3 edge cases: statelessness, timing, ancestry, residence and consent.
example_individual(edge_minor_discretionary_registration, '2010-01-10',
                   'Australia', 'British citizen', 'by descent',
                   'not British', 'not settled', 'minor application; discretion').
example_individual(edge_registration_within_twelve_months, '2011-02-20',
                   'India', 'British citizen', 'by descent',
                   'not British', 'not settled', 'application at 11 months').
example_individual(edge_registration_at_twelve_month_boundary, '2012-03-30',
                   'Pakistan', 'British citizen', 'by descent',
                   'not British', 'not settled', 'application at 12 months').
example_individual(edge_registration_after_twelve_months, '2013-04-09',
                   'United States', 'British citizen', 'by descent',
                   'not British', 'not settled', 'application at 13 months').
example_individual(edge_six_year_extension, '2014-05-19', 'Brazil',
                   'British citizen', 'by descent; qualifying grandparent',
                   'not British', 'not settled',
                   'application after 12 months; special circumstances; UK at start; 200 days absent; period ends before birth').
example_individual(edge_registration_after_six_years, '2015-06-29',
                   'South Africa', 'British citizen', 'by descent',
                   'not British', 'not settled', 'application after six years').
example_individual(edge_stateless_parentage_met, '2016-07-09', 'Egypt',
                   'British citizen', 'by descent; qualifying grandparent',
                   'not British', 'not settled',
                   'born stateless; application at 5 months').
example_individual(edge_stateless_parentage_missing, '2017-08-19', 'Mexico',
                   'British citizen', 'by descent; no qualifying grandparent',
                   'not British', 'not settled', 'born stateless').
example_individual(edge_parent_three_year_residence_270, '2018-09-29',
                   'Ireland', 'British citizen', 'by descent; qualifying grandparent',
                   'not British', 'not settled', 'UK at start; 270 days absent').
example_individual(edge_parent_three_year_residence_271, '2019-10-09',
                   'Sweden', 'British citizen', 'by descent; qualifying grandparent',
                   'not British', 'not settled',
                   'UK at start; 271 days absent; period ends before birth; application at 8 months').
example_individual(edge_parent_not_in_uk_at_period_start, '2020-11-19',
                   'Denmark', 'British citizen', 'by descent; qualifying grandparent',
                   'not British', 'not settled', 'not in UK at start of period').
example_individual(edge_parent_period_ends_after_birth, '2021-12-29',
                   'Switzerland', 'British citizen', 'by descent; qualifying grandparent',
                   'not British', 'not settled', 'residence period ends after birth').
example_individual(edge_minor_three_year_family_residence, '2008-01-08',
                   'Singapore', 'British citizen', 'by descent',
                   'British citizen', 'by descent', 'family meets 270-day test').
example_individual(edge_minor_family_exceeds_absence, '2009-02-18',
                   'New Zealand', 'British citizen', 'by descent',
                   'British citizen', 'by descent', 'one family member exceeds 270 days').
example_individual(edge_minor_both_parents_consent, '2006-03-28',
                   'Malaysia', 'British citizen', 'by descent',
                   'British citizen', 'by descent', 'both parents consent').
example_individual(edge_minor_one_parent_withholds_consent, '2007-04-07',
                   'Nigeria', 'British citizen', 'by descent',
                   'British citizen', 'by descent', 'one parent does not consent').
example_individual(edge_minor_parent_deceased, '2005-05-17',
                   'Chile', 'British citizen', 'by descent; other parent deceased',
                   'not British', 'not settled', 'surviving parent consents').
example_individual(edge_minor_parents_separated, '2004-06-27',
                   'Iceland', 'British citizen', 'by descent; parents separated',
                   'not British', 'not settled', 'either-parent reading applies').
example_individual(edge_minor_born_illegitimate, '2003-07-07',
                   'Thailand', 'British citizen', 'by descent',
                   'not British', 'not settled', 'mother-only references apply').
example_individual(edge_minor_parent_citizen_by_descent, '2002-08-17',
                   'South Korea', 'British citizen', 'by descent at birth',
                   'not British', 'not settled',
                   'qualifying grandparent otherwise than by descent; application at 11 months; UK at start; 100 days absent; period ends before birth').
example_individual(edge_minor_grandparent_citizen_at_commencement, '2001-09-27',
                   'Colombia', 'British citizen', 'by descent at birth',
                   'not British', 'not settled', 'grandparent qualified at commencement').
example_individual(edge_minor_grandparent_would_qualify_but_for_death,
                   '2000-10-07', 'Peru', 'British citizen', 'by descent at birth',
                   'not British', 'not settled', 'grandparent would qualify but for death').
example_individual(edge_ambiguous_parent_status, '1999-11-17', 'Morocco',
                   'British citizen', 'status not established',
                   'not British', 'not settled', 'incomplete evidence').
example_individual(edge_ambiguous_residency_history, '1998-12-27', 'Lebanon',
                   'British citizen', 'by descent',
                   'not British', 'not settled', 'residency dates uncertain').
