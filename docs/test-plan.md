# Test Plan: ParaBank UI Automation

| | |
|---|---|
| **Application under test** | ParaBank demo online bank by Parasoft |
| **URL** | https://parabank.parasoft.com/parabank/ |
| **Tooling** | Python 3.14, pytest, Playwright (pytest-playwright) |
| **Last updated** | 2026-11-23 |

## 1. Objective

Build an automated UI regression suite for ParaBank's main customer flows: registration, authentication, account management, money movement and loans. The suite must run repeatably against the shared public demo environment.

## 2. Scope

### In scope

| Area | Features |
|---|---|
| Security & session | Access after logout, access to other customers' accounts, HTML in user input |
| Authentication | Login, logout, invalid and empty credentials, Forgot Login Info |
| Registration | New customer, required fields, password confirmation, duplicate username |
| Accounts | Accounts Overview, Account Activity and filters, Open New Account (Checking/Savings) |
| Transfers | Transfer funds between own accounts |
| Bill Pay | Pay a payee, required fields, account verification, amount validation |
| Find Transactions | By ID, date, date range and amount |
| Profile | Update Contact Info |
| Loans | Request Loan: approved and denied |
| Public pages | Customer Care contact form, About, Services |

### Out of scope

- The SOAP/REST web services listed on the Services page. A separate API suite could cover them later.
- The Admin Page (`admin.htm`): changing it affects every user of the shared demo.
- Performance, load and security testing. The site is a public shared demo.
- Visual and pixel-level testing, accessibility audits and mobile layouts.
- Browsers other than Chromium. Firefox and WebKit can be added later through pytest-playwright's `--browser` flag.

## 3. Approach

- **Page Object Model:** one class per page. Locators and actions live in the page classes; assertions live in the tests.
- **Independent tests:** every test can run alone and in any order. Tests that need a logged-in user create a brand-new user through a fixture. The demo database is shared and reset from time to time, so the suite never relies on pre-existing accounts.
- **Unique test data:** usernames include a random suffix (for example `qa_<uuid>`).
- **Locators:** prefer roles and visible text (`get_by_role`, `get_by_text`), then stable `id`/`name` attributes. Avoid XPath and position-based selectors. See [site-reference.md](site-reference.md).
- **Negative and edge cases:** every feature includes scenarios for invalid input, boundaries (zero, negative, smallest unit, exact balance, one cent over) and unusual input (spaces, accented characters, formatted numbers, double submit). They're prioritized by risk: money movement and access control first.
- **Waiting:** use Playwright's auto-waiting `expect(...)` assertions, never fixed sleeps. Several pages (Accounts Overview, Open Account, Transfer, Update Profile) load data by AJAX after the page loads.
- **BDD test cases:** written in Gherkin (Given / When / Then) in [`features/`](../features), one file per area. Each scenario is tagged with its test case ID, priority and, where relevant, `@smoke` or `@known-issue`. The index and conventions are in [test-cases.md](test-cases.md). Each automated test should be traceable to its scenario ID.

## 4. Test environment

| Item | Value |
|---|---|
| Environment | Public demo; the only environment available |
| Browser | Chromium (Playwright build), headless by default |
| Viewport | 1280×720 |
| OS | Windows 11 (local); CI to be decided |

## 5. Entry and exit criteria

**Entry**
- The demo site is reachable and the login page loads.
- The Python virtual environment and Playwright browsers are installed (see the [README](../README.md)).

**Exit**
- All High-priority test cases are automated and passing, or failing only because of a documented [known issue](#known-issues).
- Failures caused by site defects are logged in [Known issues](#known-issues) and marked `xfail` with a reference to the issue, not deleted.
- No flaky tests: the suite passes 3 runs in a row.

## 6. Risks and mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Shared demo database is reset or changed by other users | Hard-coded users and accounts disappear | Create fresh users per test; never hard-code account numbers |
| Demo server is slow or temporarily down | Timeouts, false failures | Raise the `expect` timeout (~10 s); re-run before reporting a failure; optionally use `pytest-rerunfailures` |
| AJAX-loaded content | Assertions run before the data appears | Use web-first `expect` assertions; wait for dropdown options before submitting |
| Dynamic attributes (e.g. the Bill Pay phone `id`) | Brittle locators | Use `name` attributes or labels instead |
| Data shared between users (same SSN for many users) | Lookup returns the wrong result or none | Generate unique SSNs when testing Forgot Login Info |

## 7. Deliverables

- Automated suite in `tests/` with page objects in `pages/`
- This test plan, the Gherkin feature files in [`features/`](../features) with their [index](test-cases.md), and the [site reference](site-reference.md)
- HTML/trace reports for failed runs (optional: `pytest-html`, `--tracing retain-on-failure`)

## Known issues

Defects found while running the suite. Tag the affected scenarios with `@known-issue` and `@BUG-NN` in the feature files.

| ID | Area | Observed | Expected | Scenario |
|---|---|---|---|---|
| | | | | |
