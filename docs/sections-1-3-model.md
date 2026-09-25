# Sections 1-3 encoding notes

This is a research formalization of Sections 1-3 in
`british-nationality-1981-sections-1-30.md`, informed by Sergot and Kowalski's
1986 discussion of the earlier rule model. It is not legal advice, does not
determine anyone's status, and does not represent amended or current law.
Subsection references identify the statutory provisions the rules aim to
model, not a claim that this encoding resolves every interpretive question.

## Input convention

The rules use the `fact(Person, Property, Value)` interface backed by
`facts/rdf_facts.pl`. Facts may be supplied by a hypothetical or an external
legal or factual determination; the rules do not derive them from documentary
evidence. A compound input predicate should be read as an asserted
determination of the condition named by that predicate, not as a conclusion
independently verified by these rules.

* **Section 1:** `born_in_uk`, `after_commencement`,
  `parent_is_citizen`, and `parent_is_settled` supply the birth and parent
  conditions. The abandoned-infant presumption uses
  `found_abandoned_in_uk` and is defeated by an explicit
  `contrary_evidence_to_abandonment_presumption` fact; if that fact is absent,
  the rule treats the presumption as unrebutted. The ten-year absence test is
  supplied as the aggregate Boolean
  `first_ten_years_absence_within_90_days_each_year`. The special-circumstances
  fact stands in for the Secretary of State's decision under subsection (7).
  The subsection (3) and (4) routes use negation-as-failure to exclude people
  already derived as citizens under subsections (1) or (2); this exclusion
  depends on the supplied facts and is not a separate factual determination.
  Adoption inputs assert a UK court adoption order and the adopter's
  citizenship on the order date.
* **Section 2:** `parent_is_citizen_otherwise_than_descent` supplies the
  ordinary descent route. The RDF loader derives `parent_has_qualifying_service`
  and `parent_has_community_service` from citizenship and service/recruitment
  labels; the rules then trust these Boolean inputs. They do not separately
  test whether the parent was serving outside the UK at the child's birth.
  Designation of a service description under subsection (3), and the
  recruitment-time Community membership condition, are not modeled as
  independent determinations or processes.
* **Section 3:** `section3_parent_ancestry_qualified` summarizes the parent's
  descent and qualifying-grandparent conditions. For subsection (3)(c), the
  rule checks the supplied start-in-UK fact, that the represented period ends
  no later than birth, and an absence-day total no greater than 270.
  `born_stateless` is explicit input: the stateless route does not require
  subsection (3)(c)'s residence test. Application timing is supplied in
  months after birth; the ordinary limit is 12 months and special
  circumstances can extend it to 72 months. For subsection (5), the rule
  checks minority, a descent-citizen parent, the represented residence facts,
  and consent.

The section-specific priority predicates use numeric ranks and a comparison
rule to gate the implemented exception or alternative route. These ranks
express only the local relationships encoded here; they are not a general
statutory conflict-resolution mechanism.

## Scope limitations

The rules do not model application procedure, evidentiary standards, later
statutory amendments, or every condition in Sections 1-3. In particular,
Section 1(5)'s inputs do not separately test the commencement timing, the
child's minority, or non-citizenship before the adoption order. Section 2 does
not implement the designation and annulment procedures in subsections (3)-(4).
Section 3(1) represents the minor-application and approval conditions only.
Section 3(5) does not separately check the child's and both parents' presence
and individual absence limits, nor the family-status adjustments in
subsection (6). The Section 3 predicates express discretionary registration
or registration entitlement, not a complete account of registration
procedure or the subsequent recording of citizenship. Tests use isolated
hypothetical inputs and do not validate any real person's circumstances.
