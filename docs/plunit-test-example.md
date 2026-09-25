# Example plunit test output

This is an example successful run of the Sections 1-3 plunit suite. Run it
from the repository root after installing SWI-Prolog and the `scasp` pack:

```sh
swipl -g run_tests -t halt tests/*.pl
```

Example output:

```text
% Start unit: british_nationality_sections_1_3
% [1/12] british_nationali.._parent_citizenship ..... passed (0.004 sec)
% [2/12] british_nationali..o_qualifying_parent ..... passed (0.289 sec)
% [3/12] british_nationali..t_qualifying_parent ..... passed (0.191 sec)
% [4/12] british_nationali..rride_absence_limit ..... passed (0.446 sec)
% [5/12] british_nationali..donment_presumption ..... passed (0.380 sec)
% [6/12] british_nationali..ise_than_by_descent ..... passed (0.227 sec)
% [7/12] british_nationali.._citizen_by_descent ..... passed (0.219 sec)
% [8/12] british_nationali..ice_exception_route ..... passed (0.182 sec)
% [9/12] british_nationali..estry_and_residence ..... passed (0.204 sec)
% [10/12] british_nationali..ails_residence_test .... passed (0.205 sec)
% [11/12] british_nationali..sidence_requirement .... passed (0.206 sec)
% [12/12] british_nationali.._application_period ..... passed (0.298 sec)
% End unit british_nationality_sections_1_3: passed (2.861 sec CPU)
% All 12 tests passed in 2.884 seconds (2.877 cpu)
```

Per-test timings vary by machine. This project is a research replication, not
legal advice.
