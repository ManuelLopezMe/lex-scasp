# lex-scasp

An executable research model of Sections 1-30 of the British Nationality Act
1981, encoded in Answer Set Programming with s(CASP). The project modernizes
ideas from Sergot and Kowalski's 1986 logic-program experiment.

> **Research project only. Not legal advice.** The rules and examples do not
> determine any person's nationality or immigration status, do not capture
> every statutory condition, and do not represent amended or current law.
> Important facts and legal determinations are modeled as explicit inputs,
> rather than established from evidence.

## What's here

Rules for Sections 1-30 are in `rules/`. The rules use a shared
`fact(Person, Property, Value)` interface defined in `facts/`; some compound
facts summarize conditions the program does not independently verify. Each
rule cites the subsection it is intended to encode.

| Path | Contents |
| --- | --- |
| `rules/` | Section-specific s(CASP) rules |
| `facts/facts.pl` | Shared input-fact interface and illustrative facts |
| `tests/` | PL-Unit tests for isolated hypotheticals |
| `docs/british-nationality-1981-sections-1-30.md` | Reference text for Sections 1-30 |
| `docs/british_nationality_sergot_et_al.pdf` | Sergot and Kowalski's 1986 paper |
| `docs/sections-1-3-model.md` | Inputs, assumptions, and limitations for Sections 1-3 |
| `docs/sections-4-14-model.md` | Inputs, assumptions, and limitations for Sections 4-14 |
| `docs/sections-15-25-model.md` | Inputs, assumptions, and limitations for Sections 15-25 |
| `docs/sections-26-30-model.md` | Inputs, assumptions, and limitations for Sections 26-30 |

Read the model notes before interpreting a rule result. The tests use
hypothetical facts and exercise selected cases; they do not show that the model
is complete or that any real person's circumstances satisfy the Act.

## Requirements

- SWI-Prolog
- The s(CASP) pack for SWI-Prolog

Install s(CASP) from SWI-Prolog:

```sh
swipl -g "pack_install(scasp, [interactive(false)])" -t halt
```

## Run the tests

From the repository root:

```sh
swipl -g run_tests -t halt tests/*.pl
```

GitHub Actions runs the same test suite on pushes and pull requests.

## Source and scope

The statutory reference in `docs/` is the source text used by this project.
This research formalization does not implement every provision, Schedule,
related enactment, evidentiary standard, or application procedure, and it does
not reflect later amendments. Input facts and decisions are assumptions in a
hypothetical, not findings made by the program. The rules and examples are not
a substitute for legal interpretation.
