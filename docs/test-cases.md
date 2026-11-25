# Test Cases: ParaBank (BDD / Gherkin)

The test cases are written in Gherkin (Given / When / Then) as `.feature` files in the [`features/`](../features) folder. Exact locators and UI messages are in [site-reference.md](site-reference.md). Scope and approach are in [test-plan.md](test-plan.md).

## Feature files

| Feature file | Area | Test case IDs |
|---|---|---|
| [authentication.feature](../features/authentication.feature) | Login, logout | TC_LOGIN_01 … 09 |
| [forgot_login.feature](../features/forgot_login.feature) | Forgot login info | TC_LOOKUP_01 … 03 |
| [registration.feature](../features/registration.feature) | Customer registration | TC_REG_01 … 10 |
| [accounts.feature](../features/accounts.feature) | Overview, activity, open account | TC_ACC_01 … 06 |
| [transfer_funds.feature](../features/transfer_funds.feature) | Transfer funds | TC_TRF_01 … 10 |
| [bill_pay.feature](../features/bill_pay.feature) | Bill pay | TC_BILL_01 … 08 |
| [find_transactions.feature](../features/find_transactions.feature) | Find transactions | TC_FIND_01 … 10 |
| [update_profile.feature](../features/update_profile.feature) | Update contact info | TC_PROF_01 … 05 |
| [request_loan.feature](../features/request_loan.feature) | Request loan | TC_LOAN_01 … 06 |
| [public_pages.feature](../features/public_pages.feature) | Contact, About Us, Services | TC_PUB_01 … 05 |
| [security_session.feature](../features/security_session.feature) | Session after logout, access to other customers' data | TC_SEC_01 … 05 |

## Tag conventions

Every scenario has tags that carry the information a test-case table would hold:

| Tag | Meaning |
|---|---|
| `@TC_<AREA>_<NN>` | Test case ID, for traceability. A Scenario Outline that covers several cases carries all their IDs. |
| `@high` / `@medium` / `@low` | Priority. High = core flow; Medium = validation and secondary flows; Low = nice to have. |
| `@smoke` | Part of the smoke suite; run first. |
| `@negative` | Invalid input or a forbidden action that the application must reject. |
| `@edge` | Boundary or unusual input: limits, rounding, spacing, special characters, double submit. |
| `@needs_clarification` | ParaBank has no written specification, so the expected result is a QA assumption (for example, whether usernames are case-insensitive). Confirm it before treating a failure as a defect. |
| `@known_issue` + `@BUG_NN` | Add these when a scenario fails because of a site defect you logged in the [test plan](test-plan.md#known-issues). Automate it as an expected failure (`xfail`); don't delete it. |
| Feature-level tag (`@registration`, `@transfer`, …) | Area of the application. |

Tags use underscores, never hyphens, because pytest marker names can't contain hyphens (`pytest -m TC_LOGIN_01` works; `-m TC-LOGIN-01` doesn't).

Example: `@TC_TRF_05 @high @negative @edge` is test case TRF_05, high priority, a negative and edge case.

## Writing conventions

- **Steps describe behavior, not clicks on CSS selectors.** Locators belong in the page objects; the feature files should read like plain English.
- **Background** holds the setup shared by every scenario in a file (usually "Given I am logged in as a new customer").
- **"A new customer"** means a user registered just before the scenario with unique data. A new customer has one CHECKING account with $515.50.
- **Placeholders** in angle brackets, such as `<my username>`, `<my account>` and `<today in MM-DD-YYYY>`, are values known only at runtime. Steps resolve them from the test context.
- **Spaces in Examples tables:** Gherkin trims the spaces around a table cell, and step text already wraps values in quotes, so never quote a cell. Write meaningful spaces as `<space>` (one space) or `<N spaces>`, for example `<space>10<space>` or `<4 spaces>`.
- **Scenario Outline + Examples** are used when the same flow runs with different data (invalid logins, account types, invalid amounts).
- **Negative and edge cases** come after the `# ---------- Negative and edge cases ----------` comment in each feature file. They state the behavior a bank *should* have, which isn't necessarily what ParaBank does today.

## Smoke suite

Scenarios tagged `@smoke`: TC_REG_01, TC_LOGIN_01, TC_LOGIN_05, TC_ACC_01, TC_ACC_04/05, TC_TRF_01, TC_BILL_01, TC_LOAN_01.

## Running the features (optional)

The feature files can be run directly with [pytest-bdd](https://pytest-bdd.readthedocs.io/). Install it, write step definitions that call the page objects, and filter by tag:

```powershell
pip install pytest-bdd
pytest -m smoke                 # only @smoke scenarios
pytest -m "high and not known_issue"
```

> pytest-bdd turns Gherkin tags into pytest markers with the same names, so `@known_issue` becomes the marker `known_issue`. Register the markers in `pytest.ini` to avoid unknown-marker warnings.
