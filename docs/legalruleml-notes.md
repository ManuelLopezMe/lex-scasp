# LegalRuleML cross-check notes

The validated artifact is `legalruleml/sample_sections_1_2.lrml`. The repository
vendors separate LegalRuleML schemas by serialization profile; this document
uses the Compact profile at `legalruleml/schema/compact/lrml-compact.xsd`.
There is no `legalruleml/sections_1_2.lrml` file or
`legalruleml/schema/legalruleml.xsd` in this repository.

Research replication only; this document is not legal advice.

## s(CASP) coverage

| s(CASP) section or rule group | LegalRuleML mapping | Result |
| --- | --- | --- |
| Section 1(1), qualifying parent and birth | `BNA1981-s1-1` | Covered by the citizenship rule and its parent-citizen-or-settled condition. |
| Section 1(2), abandonment presumption and contrary evidence | `BNA1981-s1-2-presumption`, `BNA1981-s1-2-rebuttal`, and `s1-2-contrary-defeats-presumption` | Covered. The `Override` points from the higher-priority rebuttal rule to the lower-priority presumption rule. |
| Section 1(3), minor registration | `BNA1981-s1-3` | Covered as a registration obligation, though the Prolog predicate is an entitlement candidate rather than an explicit duty predicate. |
| Section 1(4), ten-year registration | `BNA1981-s1-4` | Covered as a registration obligation. |
| Section 1(5), adoption citizenship | `BNA1981-s1-5` | Covered. |
| Section 1(6), citizenship retained after an adoption order ceases | `BNA1981-s1-6` | Covered by the UK adoption-order, British adopter, and order-ceased conditions; this statement fills the omission found in the cross-check. |
| Section 1(7), special-circumstances relief | `BNA1981-s1-7` | Represented as a Secretary of State permission. The Prolog model instead adds a second s1(4) registration-entitlement candidate when special circumstances are found. |
| Section 2(1)(a), (b), and (c) | `BNA1981-s2-1a`, `BNA1981-s2-1b`, and `BNA1981-s2-1c` | Covered. The service facts in Prolog are aggregate predicates; the LRML statements unpack the qualifying-service and recruitment conditions in their descriptions and relation names. |

The model's helper predicates and final candidate-resolution machinery are not
serialized as separate statements; they are composed into the statutory
statements above. The cross-check found that Section 1(6) was missing, so
`BNA1981-s1-6` was added to mirror `section1_adoption_status_retained/1`.
Sections 1(3), 1(7), and the section 2 service conditions retain the
abstraction differences described above rather than being literal predicate
for predicate translations.

## Priorities and deontic roles

For section 1(2), `section1_rule_priority/3` assigns priority 20 to
`s1_contrary_evidence` and 10 to `s1_abandonment_presumption`. The LRML
`OverrideStatement` uses `over="#BNA1981-rule-s1-2-rebuttal"` and
`under="#BNA1981-rule-s1-2-presumption"`, preserving that ordering.

The s(CASP) section 1(3) and 1(4) candidates are both derived independently of
birth citizenship; `section1_registration` then ranks `s1_birth_status` at 30
above either registration candidate at 10. As required by the sample's
documented limitation, no `Override` is added for this conflict: the fuller
procedural model needed to represent it is not available here.

The registration obligations identify the Secretary of State as the primary
`Bearer` and the applicant as an `AuxiliaryParty` beneficiary. This is the
Compact-profile form: LRML 1.0 has no `Holder` element, and represents these
roles as deontic `ruleml:slot` entries. It captures the statutory actor and
beneficiary, but is not a literal mapping from a Prolog Bearer/Holder pair:
the s(CASP) rules conclude registration entitlement and do not model the
Secretary of State as an explicit actor. Its special-circumstances fact is the
only direct representation of the Secretary's role in the Prolog rules.
