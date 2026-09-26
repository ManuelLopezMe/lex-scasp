# Known limitations

This project is a research replication of the British Nationality Act 1981,
not legal advice. The predicates in `rules/` reason over deliberately
abstract facts; they do not determine historical evidence, interpret
secondary legislation, or make a Secretary of State decision.

## Deliberate abstractions

- **Historical and counterfactual law (sections 7-11, 14, 19, 21-23, 25-30):**
  facts such as `*_requirements_met` and `*_would_become_*` stand for the
  result of applying the incorporated 1948/1964 Acts, the Immigration Act
  1971, and commencement facts. Those Acts are not independently encoded.
- **Schedule 1 and statutory instruments (sections 2, 6, 16, 18):** service
  designations and naturalisation requirements are supplied as external
  determinations rather than reconstructed from all Schedule paragraphs or
  instruments.
- **Discretionary powers:** predicates named `may_register` or
  `may_grant_naturalisation` model the statutory prerequisites and an
  approval fact; they do not predict how discretion will be exercised.
- **Family and historical identity facts:** parentage, marriage, residence,
  service, nationality, and territorial status are atomic inputs. The model
  does not infer them from civil records.
- **Temporal units:** the rules use supplied booleans, months, days, and
  commencement-relative values. Date arithmetic, calendar boundaries, and
  evidential disputes are outside scope.
- **Delegated application provisions:** sections 24 and 29 apply sections 12
  and 13 by parallel predicates, rather than using a higher-order rule
  mechanism.

## Confirmed fixes

Section 3(5) now requires the explicit
`section3_subsection_5_family_residence_and_consent_requirements_met` fact.
Previously it checked only a parent descent fact and a parent residence
summary, which could incorrectly grant the minor route without the statutory
shared-territory, absence, and prescribed-consent conditions. Section 17(5)
already uses the equivalent explicit family determination.

The remaining simplifications recorded above are intentional modelling
boundaries, not claims that the omitted law is optional.
