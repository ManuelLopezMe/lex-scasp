# Defeasible rule resolution

This project uses s(CASP) to evaluate the statutory rules. s(CASP) does not
provide a native rule-priority directive, so each affected section explicitly
models candidates, conflicts, defeat, and acceptance in its own rule file.
This is a research formalization, not legal advice.

For each modeled conflict, section rules independently derive
section-qualified `sectionN_rule_candidate/4` conclusions for each applicable
side. A section declares incompatible outcomes with
`sectionN_rule_conflict/3` and ranks its rules with
`sectionN_rule_priority/3`. Its `sectionN_rule_defeats/4` relation is derivable
only when both candidates exist, their outcomes conflict, and the second rule
has a greater rank. Candidates remain provable even when defeated.
`sectionN_accepted_outcome/3` uses negation-as-failure only at the final
resolution step to reject a candidate for which a defeat has been derived.
The resolver is kept section-local because s(CASP) does not support
higher-order predicate calls; this avoids making independent statutory
sections compete in one global predicate.

Conflict tests should prove both candidate derivations, the defeat relation,
and the accepted winning outcome. Testing only the final answer is not enough
to show that both rules were considered. If a provision merely supplies
alternative routes to the same conclusion, it should use multiple
derivations without inventing a conflict or priority.
