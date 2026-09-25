# Sections 4-14 encoding notes

This is a research formalization of the text of Sections 4-14 in
`british-nationality-1981-sections-1-30.md`, informed by Sergot and Kowalski's
1986 discussion of the earlier rule model. It is not legal advice, does not
determine anyone's status, and does not represent amended or current law.
The source text has awkward OCR artefacts in places; subsection references in
the rules identify the intended statutory provisions, not a claim that this
encoding resolves every interpretive question.

## Input convention

The rule files use the `fact(Person, Property, Value)` interface defined in
`facts/facts.pl`. Tests supply isolated hypothetical facts; in application, a
fact may instead represent an external legal or factual determination. The
code does not infer these inputs from documentary evidence. Numeric periods
are represented in days, months, or years exactly where the predicate name
says so. Boolean negative values such as `false` are explicit evidence in the
hypothetical, not a general closed-world finding.

The following inputs intentionally encapsulate matters outside the rules:

* Sections 4-5: status categories, residence-day counts, immigration
  compliance, Community Treaty treatment, service category, and decisions
  made in special circumstances. Section 4(4)(b)'s relief input is valid only
  for a past restriction that did not remain applicable on the application
  date; the rule checks that condition.
* Section 6: Schedule 1 is not restated or approximated. Its requirements
  are represented separately as
  `section6_schedule1_general_requirements_met` and
  `section6_schedule1_spouse_requirements_met`. Full age, capacity, marriage,
  and the Secretary of State's decision remain distinct facts.
* Sections 7-11: repealed/historic enactments and counterfactual outcomes are
  explicit inputs (for example, entitlement under prior immigration and
  nationality provisions). The Section 7 residence-month total is supplied
  after crediting any legally qualifying service; types of service are
  restricted to the statutory categories, and the Section 7(5) connection
  determination is required for non-Crown service used in that calculation.
  Section 10 connection inputs use the flat predicates
  `section10_self_connection_basis`, `section10_father_connection_basis`, and
  `section10_paternal_grandfather_connection_basis`.
  Section 9's father and hypothetical legacy right-of-abode tests, Section
  10's 1964 Act entitlement, and the detailed historical statuses in Section
  11 are not reconstructed. Section 9's distinct "foreign country" birth
  condition is supplied as `section9_born_in_foreign_country`.
* Sections 12-13: the prescribed manner of declarations, satisfaction about
  alternative nationality, whether registration was withheld, nationality
  acquisition within six months, and the history/necessity of renunciation
  are facts about external events or decisions.
* Section 14: `section14_citizenship_basis` identifies the statutory route by
  which citizenship was acquired. The detailed legacy tests under subsection
  (1)(b) and (e), and the Schedule 2 paragraph 2 condition, are summarized
  as factual inputs. The service exception facts mean the service type,
  overseas posting, recruitment location, and (for Community service)
  membership status at recruitment have already been established.

The priority predicates give named higher-ranked exceptions/extensions.
Negation is used only for the explicit priority exclusions in Sections 11
and 14; Section 12 instead represents wartime withholding and non-withholding
as positive facts. Negation is not used to invent missing facts or replace
Schedule/external determinations. Numeric thresholds are tested at their
statutory edges where the encoding represents them.

## Scope limitations

Sections 4-14 cover the acquisition, historic transition, renunciation/
resumption, and descent-classification routes requested for this layer.
They do not implement application procedure, evidentiary standards, later
statutory amendments, or all related enactments and Schedules. Section 14 is
a classification predicate (`section14_by_descent/1`), not a separate
citizenship acquisition rule. Tests use isolated hypothetical inputs and do
not validate any real person's circumstances.
