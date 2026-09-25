:- use_module(library(scasp)).
:- use_module('../facts/rdf_facts.pl').

% Section 30(a): a British subject without citizenship under Section 13 or 16 of the 1948 Act continues as a British subject under this section.
section30_continues_as_british_subject(Person) :-
    fact(Person, british_subject_without_citizenship_under_1948_act_section_13_or_16_immediately_before_commencement, true).

% Section 30(b): a British subject by registration under Section 1 of the British Nationality Act 1965 continues as a British subject under this section.
section30_continues_as_british_subject(Person) :-
    fact(Person, british_subject_under_1965_act_section_1_immediately_before_commencement, true).
