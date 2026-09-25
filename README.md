# lex-scasp
The British Nationality Act 1981 encoded in Answer Set Programming (`s(CASP)`). A modernization of Sergot & Kowalski's 1986 logic-program experiment, with executable rules and automated testing.

This is a research replication, not legal advice. Rules for Sections 1-25 are
in `rules/`; illustrative RDF inputs are in `facts/`, and plunit tests are in
`tests/`. Many statutory facts are represented by explicit input predicates
rather than derived from primary records. The design and limits of the
Sections 4-14 and 15-25 encodings are described in
`docs/sections-4-14-model.md` and `docs/sections-15-25-model.md`. This code
and its examples are not a substitute for legal interpretation and do not
purport to reproduce amended or current law.
