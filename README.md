# lex-scasp

An executable research model of selected provisions of the British Nationality
Act 1981, encoded in Answer Set Programming with s(CASP). The project
modernizes ideas from Sergot and Kowalski's 1986 logic-program experiment.

> **Research project only. Not legal advice.** The rules and examples do not
> determine any person's nationality or immigration status, do not capture
> every statutory condition, and do not represent amended or current law.
> Important facts and legal determinations are modeled as explicit inputs,
> rather than established from evidence.

## What's here

The repository contains rule files for Sections 1-14, hypothetical RDF-backed
facts, and automated tests. Each rule cites the subsection it is intended to
encode. The rules use the `fact(Person, Property, Value)` interface; some
compound facts summarize conditions that the program does not independently
verify.

| Path | Contents |
| --- | --- |
| `rules/` | Section-specific s(CASP) rules |
| `facts/rdf_facts.pl` | Illustrative RDF records and derived input facts |
| `tests/` | PL-Unit tests for isolated hypotheticals |
| `docs/british-nationality-1981-sections-1-30.md` | Reference text for Sections 1-30 |
| `docs/british_nationality_sergot_et_al.pdf` | Sergot and Kowalski's 1986 paper |
| `docs/sections-1-3-model.md` | Inputs, assumptions, and limitations for Sections 1-3 |
| `docs/sections-4-14-model.md` | Inputs, assumptions, and limitations for Sections 4-14 |

See the model notes before interpreting a rule result. The tests exercise
selected boundaries and hypotheticals; they are not evidence that the model is
complete or that a real person's circumstances satisfy the Act.

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

The same command is run by GitHub Actions on pushes and pull requests.

## Source and scope

The statutory reference in `docs/` is used as the project's source text. This
repository is a research formalization, not a complete implementation of the
Act or its Schedules, related legislation, evidentiary standards, application
procedures, or later amendments. Where rule inputs represent external facts or
decisions, those are assumptions of a hypothetical, not findings made by the
program.
