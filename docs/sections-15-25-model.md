# Sections 15-25 encoding notes

This is a research formalization of Sections 15-25 of the British Nationality
Act 1981, based on `british-nationality-1981-sections-1-30.md` and informed by
Sergot and Kowalski's 1986 paper, `british_nationality_sergot_et_al.pdf`. It is
not legal advice, does not determine anyone's status, and does not represent
amended or current law. Tests describe isolated hypotheticals, not real people.

## Input convention and citizenship classes

Rules use `fact(Person, Property, Value)` from `facts/rdf_facts.pl`. Inputs may
represent facts supplied for a hypothetical or determinations made outside
this program. In particular, absence of a fact is not generally treated as
proof of a negative. The rule set keeps British Dependent Territories (BDT)
citizenship distinct from British citizenship: rules in Sections 15-25 use
BDT-specific inputs and outputs, and Section 24 implements its application of
Sections 12-13 against BDT-citizenship facts rather than relying on
`british_citizen` or British-citizenship renunciation facts.

## Deliberate abstractions

* **Section 15:** birth territory, parent status/settlement at birth, parent
  status changes while a child is a minor, and adoption-order facts are
  explicit. For the abandoned-newborn presumption,
  `section15_parentage_contrary_shown` must be explicitly `false`; the rules do
  not infer that no contrary evidence exists. The ten-year residence input
  `section15_each_first_ten_years_absence_at_most_90_days` summarizes the
  annual test at its statutory 90-day threshold. Special-circumstances relief
  remains a separate Secretary of State input.
* **Section 16:** whether a service description has been designated under
  subsection (3) is an explicit input; the program does not invent a
  designation or determine whether a service is closely associated with a
  territory's government.
* **Section 17:** the birth-registration route takes the parent/grandparent
  status, the three-year/270-day residence determination, application window,
  and statelessness as inputs. In the stateless case subsection (2)(c)'s
  residence condition is not required. The subsection (5)-(6) shared-territory,
  absence and consent conditions are summarized as
  `section17_subsection_5_family_residence_and_consent_requirements_met`,
  after applying the appropriate family references in subsection (6).
* **Section 18:** Schedule 1 requirements for general and spouse
  naturalisation are separate external determinations. Full age, capacity,
  marriage to a BDT citizen on the application date, specification of the
  relevant dependent territory, and the Secretary of State's discretion are
  not inferred from those determinations.
* **Section 19:** `section19_immigration_act_schedule_1_paragraph_2_counterfactual_entitlement`
  captures the historic counterfactual under paragraphs 2-5 of Schedule 1 to
  the Immigration Act 1971. Application periods and special-circumstances
  extensions are separate inputs.
* **Section 20:** entitlement under section 6(2) of the British Nationality
  Act 1948, marriage history, the husband's BDT status and renunciation, and
  the Secretary of State's decision are explicit facts; historic marriage law
  is not reconstructed.
* **Section 21:** the adapted section 9 father requirements and the
  section 23(1)(b) counterfactual are explicit determinations, as are the
  foreign-country birth, five-year birth window and twelve-month application
  window.
* **Section 22:** historic entitlement under section 1(1) of the British
  Nationality Act 1964 and pre-commencement renunciation are explicit. The
  `section22_connection_qualification` value records one of the four grounds
  in subsection (4), established for the applicant, their father or their
  father's father. A spouse's connection and the woman's status are separate
  inputs.
* **Section 23:** earlier CUKC acquisition, registration routes, parent links,
  historical male-line criteria, and spouse outcomes are inputs where they
  depend on repealed enactments or complex historical status. The
  `section23_connection_qualification` input records one of the four
  subsection (5) grounds, established for the person, their father or their
  father's father. The historic CUKC determinations used for subsection
  (1)(b) account for subsection (6)'s construction of pre-1949 references to
  CUKC as references to British nationality.
* **Section 24:** its Section 12 and 13 application is represented by
  `section24_`-prefixed declaration, nationality, cessation, renunciation,
  and prior-registration facts. The independent interface prevents British
  citizenship facts alone from establishing BDT renunciation or resumption.
* **Section 25:** `section25_citizenship_basis` identifies the statutory
  acquisition or registration route. Historic 1948-1965 Act classifications,
  Schedule 2 paragraph 1 status and the specified counterfactuals are explicit
  inputs. For subsection (2), service type, service abroad, local recruitment,
  and (for designated service) designation under section 16(3) are separate
  facts. Explicit priority ranks give the service exception precedence only
  over the historic routes in subsection (1)(b), (d), (e) and (f). This section
  classifies whether a BDT citizen is by descent; it does not itself confer
  citizenship.

The priority predicates model statutory precedence rather than deriving legal
facts. The source paper discusses why the Act's structure requires extensions
to simple Horn-clause logic; this encoding keeps external historic facts and
discretionary decisions visible instead of filling those gaps with invented
law. Tests cover positive and negative routes, statutory exceptions,
thresholds, and interaction between Sections 15-25 and the inherited
Sections 4-14. They do not validate any real person's circumstances.
