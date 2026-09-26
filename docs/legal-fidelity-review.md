# Legal fidelity review

This review compares the current predicates with the transcription in
`docs/british-nationality-1981-sections-1-30.md`. It is an academic code
review of a research replication, not legal advice. “Abstracted” means that
the rule delegates a historical, evidential, or discretionary determination
to a fact; “gap” identifies a defect in the rule itself.

## Part I: British citizenship

### Section 1 — Acquisition by birth or adoption

> “A person born in the United Kingdom after commencement shall be a British
> citizen if ... his father or mother is ... a British citizen; or settled in
> the United Kingdom.” Subsections (2)-(7) add abandoned infants, minor
> registration, the ten-year residence route, adoption, and special
> circumstances.

The encoding covers the parent/settlement birth route, a defeasible abandoned
infant presumption, both registration routes, adoption, and continuation after
an adoption order ceases. Historical evidence and the Secretary of State’s
special-circumstances judgment are abstracted as facts. **Finding: aligned
within the stated abstraction boundary.**

### Section 2 — Acquisition by descent

> “A person born outside the United Kingdom after commencement shall be a
> British citizen if ... his father or mother is such a citizen otherwise
> than by descent,” including the recruited Crown/designated-service and
> Community-institution alternatives.

The three routes are represented by `parent_is_citizen_otherwise_than_descent`,
`parent_has_qualifying_service`, and `parent_has_community_service`; overseas
birth and commencement are required. The detailed service designation and
recruitment evidence are abstracted. **Finding: aligned, abstracted service
details.**

### Section 3 — Acquisition by registration: minors

> “If while a person is a minor an application is made ... the Secretary of
> State may” register. The entitlement routes require an overseas birth,
> twelve-month (or six-year discretionary) filing period, descent ancestry,
> and, for non-stateless applicants, three years’ residence with no more than
> 270 days’ absence. Subsection (5) requires the child and parents’ shared
> residence, absence limits, and prescribed consent.

The discretionary and subsection (2) routes are represented, with the
stateless residence exception. **Confirmed gap fixed:** subsection (5) now
requires one explicit family residence/absence/consent determination instead
of checking only the parent’s residence summary. The detailed family
calculation remains abstracted.

### Section 4 — Registration: BDT citizens etc.

> The section applies to BDT citizens, British Overseas citizens, British
> subjects, and British protected persons. The ordinary route requires
> five-year presence, no more than 450 days’ absence, no final-year
> restriction, and no breach; special circumstances modify those tests.

The covered statuses, application, four tests, priority-based special relief,
and qualifying service route are encoded. The statutory service categories
and ministerial evaluation are fact inputs. **Finding: aligned, abstracted
service and discretion.**

### Section 5 — Community Treaties

> A BDT citizen treated as a United Kingdom national for Community Treaty
> purposes is entitled to registration on application.

The three statutory conditions are direct predicates. The underlying Treaty
status is an external fact. **Finding: aligned.**

### Section 6 — Naturalisation

> The Secretary of State may grant naturalisation to an applicant of full age
> and capacity who satisfies Schedule 1, with a parallel route for a person
> married to a British citizen.

Both routes require application, age, capacity, the relevant Schedule 1
determination, and approval. Schedule 1 itself is intentionally not encoded.
**Finding: aligned, Schedule 1 abstracted.**

### Section 7 — Residence or relevant employment

> Subsection (1) preserves two historical five-year routes. Subsection (2)
> covers residence ending at commencement, continued residence/right of
> abode, and five years’ residence; relevant service may count, subject to a
> close-connection decision. Sections (6) and (8) permit eight-year
> extensions.

The two historical routes, windows, residence/right-of-abode tests, service
categories, close connection, and extensions are represented. The incorporated
Immigration Act and 1948 Act tests are abstracted. **Finding: aligned,
abstracted historical law.**

### Section 8 — Registration by marriage

> A qualifying pre-commencement wife has a mandatory five-year route; former
> marriage and current-marriage/renunciation cases are discretionary.

All three routes include the historical marriage facts, five-year window, the
husband’s commencement/renunciation status, and approval where required.
**Finding: aligned, historical entitlement abstracted.**

### Section 9 — Father’s citizenship etc.

> An overseas-born person born within five years may register within twelve
> months if the father satisfies subsection (2) and the counterfactual
> right-of-abode test is met.

The birth and application windows, application, paternal determination, and
counterfactual are represented. **Finding: aligned, subsection (2)
determination abstracted.**

### Section 10 — Registration after renunciation

> A person with the preserved 1964 Act resumption entitlement may register
> once; a full-capacity former CUKC renouncer may also be registered
> discretionarily where the qualifying connection exists.

The personal, paternal, and grandfather connection bases, married-woman
alternative, once-only bar, capacity, renunciation, application, and
approval are represented. The 1964 Act test is abstracted. **Finding:
aligned, historical law abstracted.**

### Section 11 — Commencement citizenship

> A CUKC with the right of abode becomes British at commencement, subject to
> the maternal stateless-registration exception; subsection (3) supplies a
> male-line High Commissioner route.

The ordinary and maternal candidates are resolved with explicit priority, and
the subsection (3) historical qualification is an external fact. **Finding:
aligned, historical qualification abstracted.**

### Section 12 — Renunciation

> A British citizen of full age and capacity may make a prescribed
> renunciation; registration is subject to the other-nationality safeguard
> and may be withheld during a qualifying war. A person who has been married
> is deemed of full age.

Age, marriage, capacity, prescribed form, nationality safeguard, six-month
effect, and wartime withholding are encoded with explicit priority.
**Finding: aligned.**

### Section 13 — Resumption

> A former citizen whose renunciation was necessary for another nationality
> is entitled to register once; a full-capacity former citizen may otherwise
> be registered at discretion.

Both routes, application, capacity, necessary-renunciation condition, and
once-only bar are encoded. **Finding: aligned.**

### Section 14 — “By descent”

> A British citizen is by descent only in the listed section 2, 3, 5, 8,
> 9, 10, 13, and Schedule 2 cases, with a historical service exception.

The listed ordinary and historical bases and service exception are encoded
with priority. The underlying historic status tests are external facts.
**Finding: aligned, historical law abstracted.**

## Part II: British Dependent Territories citizenship

### Section 15 — Acquisition by birth or adoption

> Birth in a dependent territory to a BDT citizen or settled parent qualifies;
> abandoned infants, minor registration, the ten-year absence route,
> adoption, order cessation, and special circumstances are provided.

The birth, abandonment, minor, ten-year, adoption, continuation, and
special-relief routes are represented. The facts summarising annual absence
and status before registration are deliberate abstractions. **Finding:
aligned.**

### Section 16 — Acquisition by descent

> Overseas birth after commencement to a BDT citizen otherwise than by
> descent, or to a citizen serving in qualifying service recruited in a
> dependent territory, confers citizenship.

Both parent routes, overseas service, local recruitment, and designated
service are encoded. Designation by statutory instrument is an input.
**Finding: aligned, instrument abstracted.**

### Section 17 — Acquisition by registration: minors

> The section provides discretionary minor registration, a twelve-month
> (extendable to six years) ancestry/residence route, a stateless exception,
> and a minor route requiring shared territory, absence limits, and consent.

The rules cover all routes and already use an explicit
`section17_subsection_5_family_residence_and_consent_requirements_met`
determination for subsection (5)-(6). **Finding: aligned, family calculation
abstracted.**

### Section 18 — Naturalisation

> The Secretary of State may grant naturalisation to a person of full age and
> capacity who satisfies Schedule 1, including a spouse route; the relevant
> dependent territory must be specified.

Both routes require the application, age/capacity, specified territory,
Schedule 1 determination, and approval. **Finding: aligned, Schedule 1
abstracted.**

### Section 19 — Residence in dependent territory

> The section preserves the Immigration Act paragraph 2 route for five years,
> with the commencement-to-majority and special eight-year extensions.

The ordinary, minor, and extended windows, application, and counterfactual
entitlement are represented. **Finding: aligned, incorporated law abstracted.**

### Section 20 — Registration by marriage

> The section parallels section 8 for BDT citizenship: mandatory continuous
> marriage, discretionary former marriage, and discretionary current
> marriage after renunciation.

All three routes and their five-year windows are represented. Historical
section 6(2) status and ministerial discretion are facts. **Finding: aligned.**

### Section 21 — Father’s citizenship etc.

> A foreign-born person within five years may register within twelve months
> where the adapted section 9 father tests and section 23(1)(b)
> counterfactual are satisfied.

The birth/application windows, adapted paternal determination, and section 23
counterfactual are direct predicates. **Finding: aligned, incorporated
requirements abstracted.**

### Section 22 — Registration replacing resumption

> The 1964 Act qualifying-connection entitlement is preserved once only; a
> full-capacity former CUKC renouncer may also be registered discretionarily.

The four territorial connection bases, married-woman alternative, once-only
bar, capacity, renunciation, application, and approval are represented.
**Finding: aligned, 1964 Act status abstracted.**

### Section 23 — Commencement BDT citizenship

> CUKCs acquire BDT citizenship through territorial birth, naturalisation or
> registration; qualifying parent, marriage, minor/stateless, male-line,
> resumption, and annexation routes also apply.

Each listed route and the four connection bases is represented through
explicit fact determinations. **Finding: aligned, historical status
determinations abstracted.**

### Section 24 — Renunciation and resumption

> “The provisions of sections 12 and 13 shall apply” to BDT citizens and
> citizenship.

The implementation mirrors sections 12 and 13 with BDT-specific predicates,
including age-by-marriage, nationality safeguard, wartime withholding,
resumption, and once-only entitlement. **Finding: aligned by explicit
delegated copy.**

### Section 25 — “By descent”

> A BDT citizen is by descent only in the listed section 16, 17, 21, 22,
> 23, 20, 24, and Schedule 2 cases, subject to the dependent-territory
> service exception.

The ordinary and historical bases and explicit service-priority resolution
are encoded. Historical conditions and Schedule 2 are fact inputs. **Finding:
aligned, historic law abstracted.**

## Part III: British Overseas citizenship

### Section 26 — Commencement BOC citizenship

> A CUKC who becomes neither British nor BDT at commencement becomes a
> British Overseas citizen.

The rule requires the CUKC status and explicitly false outcomes for the two
excluded citizenships. **Finding: aligned.**

### Section 27 — Registration of minors

> A minor may be registered discretionarily; a foreign-born person within five
> years may register within twelve months where adapted section 9 and section
> 26 counterfactual conditions are met.

Both routes, windows, application, adapted paternal requirements, and the
section 26 counterfactual are represented. **Finding: aligned, incorporated
tests abstracted.**

### Section 28 — Registration by marriage

> The section parallels section 8 for BOC citizenship, covering mandatory
> continuous marriage, former marriage, and current marriage after
> renunciation.

All three routes include the five-year window, marriage/history conditions,
husband status, and approval where discretionary. **Finding: aligned.**

### Section 29 — Renunciation

> “The provisions of section 12 shall apply” to BOC citizens and citizenship.

The implementation mirrors section 12 with BOC-specific predicates and
preserves the other-nationality, six-month, and wartime rules. **Finding:
aligned by explicit delegated copy.**

## Part IV: British subjects

### Section 30 — Continuance

> A British subject without citizenship under section 13 or 16 of the 1948
> Act, or registered under section 1 of the 1965 Act, continues as a British
> subject.

Both statutory categories are represented as separate alternatives, with no
unlisted category accepted. The historical status determinations are facts.
**Finding: aligned.**

## Review conclusion

One rule-level fidelity defect was confirmed and corrected: section 3(5)’s
family residence/absence/consent gate. The other sections either match the
quoted statutory conditions at the predicate level or deliberately delegate
historical law, evidence, schedules, instruments, and discretion as
documented in `docs/known-limitations.md`.
