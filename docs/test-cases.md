# Test Cases: ParaBank (BDD / Gherkin)

The test cases are written in Gherkin (Given / When / Then) as `.feature` files in the [`features/`](../features) folder. Exact locators and UI messages are in [site-reference.md](site-reference.md). Scope and approach are in [test-plan.md](test-plan.md).

## Feature files

| Feature file | Area | Test case IDs |
|---|---|---|
| [authentication.feature](../features/authentication.feature) | Login, logout | TC-LOGIN-01 … 09 |
| [forgot_login.feature](../features/forgot_login.feature) | Forgot login info | TC-LOOKUP-01 … 03 |
| [registration.feature](../features/registration.feature) | Customer registration | TC-REG-01 … 10 |
| [accounts.feature](../features/accounts.feature) | Overview, activity, open account | TC-ACC-01 … 06 |
| [transfer_funds.feature](../features/transfer_funds.feature) | Transfer funds | TC-TRF-01 … 10 |
| [bill_pay.feature](../features/bill_pay.feature) | Bill pay | TC-BILL-01 … 08 |
| [find_transactions.feature](../features/find_transactions.feature) | Find transactions | TC-FIND-01 … 08 |
| [update_profile.feature](../features/update_profile.feature) | Update contact info | TC-PROF-01 … 05 |
| [request_loan.feature](../features/request_loan.feature) | Request loan | TC-LOAN-01 … 06 |
| [public_pages.feature](../features/public_pages.feature) | Contact, About Us | TC-PUB-01 … 04 |
| [security_session.feature](../features/security_session.feature) | Session after logout, access to other customers' data | TC-SEC-01 … 05 |

## Tag conventions

Every scenario has tags that carry the information a test-case table would hold:

| Tag | Meaning |
|---|---|
| `@TC-<AREA>-<NN>` | Test case ID, for traceability. A Scenario Outline that covers several cases carries all their IDs. |
| `@high` / `@medium` / `@low` | Priority. High = core flow; Medium = validation and secondary flows; Low = nice to have. |
| `@smoke` | Part of the smoke suite; run first. |
| `@negative` | Invalid input or a forbidden action that the application must reject. |
| `@edge` | Boundary or unusual input: limits, rounding, spacing, special characters, double submit. |
| `@needs-clarification` | ParaBank has no written specification, so the expected result is a QA assumption (for example, whether usernames are case-insensitive). Confirm it before treating a failure as a defect. |
| `@known-issue` + `@BUG-NN` | Add these when a scenario fails because of a site defect you logged in the [test plan](test-plan.md#known-issues). Automate it as an expected failure (`xfail`); don't delete it. |
| Feature-level tag (`@registration`, `@transfer`, …) | Area of the application. |

Example: `@TC-TRF-05 @high @edge` is test case TRF-05, high priority, an edge case.

## Writing conventions

- **Steps describe behavior, not clicks on CSS selectors.** Locators belong in the page objects; the feature files should read like plain English.
- **Background** holds the setup shared by every scenario in a file (usually "Given I am logged in as a new customer").
- **"A new customer"** means a user registered just before the scenario with unique data. A new customer has one CHECKING account with $515.50.
- **Placeholders** in angle brackets, such as `<my username>`, `<my account>` and `<today in MM-DD-YYYY>`, are values known only at runtime. Steps resolve them from the test context.
- **Scenario Outline + Examples** are used when the same flow runs with different data (invalid logins, account types, invalid amounts).
- **Negative and edge cases** come after the `# ---------- Negative and edge cases ----------` comment in each feature file. They state the behavior a bank *should* have, which isn't necessarily what ParaBank does today.

## Smoke suite

Scenarios tagged `@smoke`: TC-REG-01, TC-LOGIN-01, TC-LOGIN-05, TC-ACC-01, TC-ACC-04/05, TC-TRF-01, TC-BILL-01, TC-LOAN-01.

## Running the features (optional)

The feature files can be run directly with [pytest-bdd](https://pytest-bdd.readthedocs.io/). Install it, write step definitions that call the page objects, and filter by tag:

```powershell
pip install pytest-bdd
pytest -m smoke                 # only @smoke scenarios
pytest -m "high and not known_issue"
```

> pytest-bdd turns Gherkin tags into pytest markers. Tags with hyphens (`@known-issue`, `@TC-LOGIN-01`) must be referenced with underscores in `-m` expressions, or the marker names adjusted, depending on your pytest-bdd version. Register the markers in `pytest.ini` to avoid warnings.
