# AGENTS.md

## Purpose
Encoding the British Nationality Act 1981 in s(CASP), modernizing 
Sergot & Kowalski's 1986 logic-program experiment. Research 
replication, not legal advice — every README/PR referencing outcomes 
should say so.

## Build & test
- Install deps: `swipl -g "pack_install(scasp)."`
- Run tests: `swipl -g run_tests -t halt tests/*.pl`
- CI runs the above on every push/PR via .github/workflows.

## Conventions
- One file per statute section (or closely related group) in /rules, 
  named by section number.
- Every rule has a comment citing the exact subsection it encodes.
- Overrides/exceptions are encoded as independently derivable candidates and
  explicit priority/defeat rules; reserve negation-as-failure for rejecting a
  defeated candidate at final resolution, never for gating the lower-priority
  rule out of consideration. See `docs/defeasible-rules.md`.
- Commit messages describe the legal outcome a change enables or 
  fixes, not just "add section N".
- Test cases live in /tests, one hypothetical per test; where 
  feasible, also assert on the s(CASP) justification tree, not just 
  the final answer.

## Source
Use `docs\british-nationality-1981-sections-1-30.md` as a reference to the British Nationality Act
