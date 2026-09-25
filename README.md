# lex-scasp
The British Nationality Act 1981 encoded in Answer Set Programming (`s(CASP)`). A modernization of Sergot & Kowalski's 1986 logic-program experiment, with executable rules and automated testing.

This is a research replication, not legal advice. The initial rules for
Sections 1-3 are in `rules/`; illustrative RDF inputs are in `facts/`, and
their plunit tests are in `tests/`. These examples abstract some statutory
facts (such as qualifying absence periods) as explicit RDF properties; they
are not a substitute for legal interpretation.
