# Sections 26-30 encoding notes

This is a research formalization of Sections 26-30 of the British Nationality
Act 1981, based on `british-nationality-1981-sections-1-30.md` and informed by
Sergot and Kowalski's 1986 paper, `british_nationality_sergot_et_al.pdf`. It is
not legal advice, does not determine anyone's status, and does not represent
amended or current law. Tests describe isolated hypotheticals, not real people.

Rules use `fact(Person, Property, Value)`; absence of a fact is not evidence of
its negation. British citizenship, BDT citizenship, BOC, and British-subject
status remain distinct. Section 26 requires explicit evidence that a
pre-commencement CUKC becomes neither of the two other citizenships at
commencement. Section 27(2)'s Section 9(2)(a) historic father determination,
its adapted Section 9(2)(b) test (becoming and continuously holding at least
one of British, BDT or BOC citizenship throughout, or would have become one
but for death), and the Section 26 birth counterfactual are separate explicit
inputs. It does not reuse Section 9's ordinary British citizenship result or
infer the historic tests.

Section 28 keeps its mandatory route and two discretionary routes separate.
The five-year application window is represented in months; historic Section
6(2) entitlement, marriage facts, a husband's BOC status, renunciation, and
death counterfactuals are explicit inputs. Section 29 mirrors Section 12's
declaration, nationality safety, six-month, wartime-withholding and married-age
conditions with BOC-specific properties and outcomes, so British/BDT
citizenship facts alone cannot establish or end BOC status. Section 30
recognizes only the two categories in paragraphs (a) and (b); the underlying
historic status determinations are supplied as facts.
