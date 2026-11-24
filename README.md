# ParaBank UI Automation with Playwright

Automated UI tests for [ParaBank](https://parabank.parasoft.com/parabank/), Parasoft's demo online bank, written in Python with [Playwright](https://playwright.dev/python/) and pytest.

## Documentation

| Document | Contents |
|---|---|
| [Test plan](docs/test-plan.md) | Scope, approach, environment, risks, entry/exit criteria, known issues log |
| [Test cases](docs/test-cases.md) | Index of the BDD test cases, tag conventions and the smoke suite |
| [Feature files](features/) | Test cases written in Gherkin (Given / When / Then), one `.feature` file per area |
| [Site reference](docs/site-reference.md) | Pages, locators and exact UI messages of ParaBank |

## Tech stack

- Python 3.14
- pytest
- Playwright for Python (`pytest-playwright`), Chromium

## Project structure

```
qa-playwright-project/
├── docs/              # test plan, test case index, site reference
├── features/          # BDD test cases in Gherkin (.feature files)
├── pages/             # page objects (one class per ParaBank page)
├── tests/             # pytest test files
├── conftest.py        # shared fixtures and browser settings
├── pytest.ini         # pytest options (test path, browser, base URL)
└── requirements.txt   # Python dependencies
```

## Setup

Requires Python 3.14+.

```powershell
# 1. Clone the repository
git clone https://github.com/10AndresR10/qa-playwright-project.git
cd qa-playwright-project

# 2. Create and activate a virtual environment
python -m venv .venv
.\.venv\Scripts\Activate.ps1        # Windows PowerShell
# source .venv/bin/activate         # macOS / Linux

# 3. Install dependencies and the browser
pip install -r requirements.txt
playwright install chromium
```

## Running the tests

```powershell
pytest                                   # all tests, headless
pytest tests/test_login.py               # one file
pytest -k "login"                        # tests whose name matches
pytest --headed --slowmo 300             # watch the browser, slowed down
pytest --browser firefox                 # another browser (install it first)
pytest --tracing retain-on-failure       # keep a trace for failed tests
playwright show-trace test-results/<test>/trace.zip
```

The site's base URL is set in `pytest.ini` (`--base-url`), so tests can navigate with relative paths such as `page.goto("index.htm")`.

## Notes about the test environment

- ParaBank is a **shared public demo**. Its database is reset from time to time and other people use it at the same time. Tests should create their own users with unique data instead of relying on fixed accounts.
- The server can be slow. If tests fail with timeouts, re-run them before reporting a failure.
- Log defects you find in the site in the [test plan](docs/test-plan.md#known-issues).
