# ParaBank Site Reference

Field names, locators and exact messages on the ParaBank demo site, collected by exploring the live site on 2026-11-23. Use it when writing page objects and assertions.

- **Base URL:** `https://parabank.parasoft.com/parabank/`
- **Page layout:** every page has a header login form (logged out) or a `#leftPanel` menu (logged in), plus a main content area `#rightPanel`.
- **Error messages:** form validation errors are `span.error` elements next to each field. Page-level errors appear in `#rightPanel` under an `Error!` heading as `p.error`.

> The site is a shared public demo. Its database is reset from time to time, and many people register users with the same data (for example the SSN), so don't hard-code accounts or account numbers.

---

## Public pages (logged out)

### Home / Login: `index.htm`

| Element | Locator |
|---|---|
| Username | `input[name='username']` |
| Password | `input[name='password']` |
| Log In button | `input[value='Log In']` |
| Forgot login info? link | `get_by_role("link", name="Forgot login info?")` |
| Register link | `get_by_role("link", name="Register")` |

| Scenario | Result |
|---|---|
| Valid credentials | Redirects to `overview.htm`, heading **Accounts Overview** |
| Wrong credentials | `login.htm`, heading `Error!`, message **The username and password could not be verified.** |
| Empty username and password | Heading `Error!`, message **Please enter a username and password.** |

### Register: `register.htm`

All field ids contain dots, so use the attribute form: `[id='customer.firstName']`. (In CSS, `#customer.firstName` would mean id `customer` with class `firstName`.)

| Field | id | Required error |
|---|---|---|
| First Name | `customer.firstName` | First name is required. |
| Last Name | `customer.lastName` | Last name is required. |
| Address | `customer.address.street` | Address is required. |
| City | `customer.address.city` | City is required. |
| State | `customer.address.state` | State is required. |
| Zip Code | `customer.address.zipCode` | Zip Code is required. |
| Phone # | `customer.phoneNumber` | *(optional)* |
| SSN | `customer.ssn` | Social Security Number is required. |
| Username | `customer.username` | Username is required. |
| Password | `customer.password` | Password is required. |
| Confirm | `repeatedPassword` | Password confirmation is required. |
| Register button | `input[value='Register']` | |

| Scenario | Result |
|---|---|
| Success | Heading **Welcome &lt;username&gt;**, text **Your account was created successfully. You are now logged in.** The user is logged in with one CHECKING account holding **$515.50**. |
| Passwords differ | **Passwords did not match.** |
| Username taken | **This username already exists.** |

### Forgot Login Info: `lookup.htm`

Fields (no `customer.` prefix here): `firstName`, `lastName`, `address.street`, `address.city`, `address.state`, `address.zipCode`, `ssn`. Button: `input[value='Find My Login Info']`.

- **Empty form:** the same required-field messages as Register, from First name through SSN (7 messages).
- **No matching customer:** **The customer information provided could not be found.**

### Contact / Customer Care: `contact.htm`

Fields: `#name`, `#email`, `#phone`, `#message` (textarea). Button: `input[value='Send to Customer Care']`.

**Empty form:** Name is required. / Email is required. / Phone is required. / Message is required.

### Static pages

| Page | URL | Title |
|---|---|---|
| About Us | `about.htm` | ParaBank \| About Us |
| Services | `services.htm` | ParaBank \| Services |

---

## Logged-in pages

### Left menu (`#leftPanel`)

Shows `Welcome <First> <Last>` (`#leftPanel .smallText`), then the links: Open New Account, Accounts Overview, Transfer Funds, Bill Pay, Find Transactions, Update Contact Info, Request Loan, Log Out.

**Log Out** returns to `index.htm` and shows the login form again.

### Accounts Overview: `overview.htm`

- Table `#accountTable`, with the columns **Account**, **Balance\***, **Available Amount**.
- Each account number is a link to `activity.htm?id=<accountId>`. Account rows: `#accountTable tbody a`.
- The last body row is **Total**. The footer reads *\*Balance includes deposits that may be subject to holds*.
- The table loads by AJAX, so wait for the rows before asserting on them.

### Account Activity: `activity.htm?id=<id>`

- **Account Details:** Account Number, Account Type (CHECKING/SAVINGS), Balance, Available.
- **Filters:** `#month` (All, January to December), `#transactionType` (All, Credit, Debit), and the button `input[value='Go']`.
- **No transactions:** shows **No transactions found.**

### Open New Account: `openaccount.htm`

| Element | Locator |
|---|---|
| Account type | `#type` with options `CHECKING` (0) and `SAVINGS` (1) |
| Funding account | `#fromAccountId`, filled by AJAX |
| Button | `input[value='Open New Account']` |

- **Note on the page:** A minimum of $100.00 must be deposited into this account at time of opening.
- **Success:** heading **Account Opened!**, text **Congratulations, your account is now open.**, and the new number as the link `#newAccountId`.

### Transfer Funds: `transfer.htm`

| Element | Locator |
|---|---|
| Amount | `#amount`. Note: its `name` is `input`. |
| From account | `#fromAccountId` |
| To account | `#toAccountId` |
| Button | `input[value='Transfer']` |

- **Success:** heading **Transfer Complete!**, text **$25.00 has been transferred from account #A to account #B.**
### Bill Pay: `billpay.htm`

Use the `name` attributes. The phone field's `id` is a random value that changes on every page load.

| Field | name | Required error |
|---|---|---|
| Payee Name | `payee.name` | Payee name is required. |
| Address | `payee.address.street` | Address is required. |
| City | `payee.address.city` | City is required. |
| State | `payee.address.state` | State is required. |
| Zip Code | `payee.address.zipCode` | Zip Code is required. |
| Phone # | `payee.phoneNumber` | Phone number is required. |
| Account # | `payee.accountNumber` | Account number is required. |
| Verify Account # | `verifyAccount` | Account number is required. |
| Amount | `amount` | The amount cannot be empty. |
| From account | `select[name='fromAccountId']` | |
| Button | `input[value='Send Payment']` | |

| Scenario | Result |
|---|---|
| Account numbers differ | **The account numbers do not match.** |
| Non-numeric amount | **Please enter a valid amount.** |
| Success | Heading **Bill Payment Complete**, text **Bill Payment to &lt;payee&gt; in the amount of $10.00 from account &lt;id&gt; was successful.** |

### Find Transactions: `findtrans.htm`

The account is selected with `#accountId`. There are four search options, each with its own button:

| Search | Input(s) | Button |
|---|---|---|
| By transaction ID | `#transactionId` | `#findById` |
| By date (MM-DD-YYYY) | `#transactionDate` | `#findByDate` |
| By date range | `#fromDate`, `#toDate` | `#findByDateRange` |
| By amount | `#amount` | `#findByAmount` |

- **Empty amount:** **Invalid amount**
- **Results:** heading **Transaction Results**, with the columns Date, Transaction, Debit (-), Credit (+). A transfer appears as *Funds Transfer Sent* / *Funds Transfer Received*.

### Update Contact Info: `updateprofile.htm`

- **Fields:** the same ids as Register, from `customer.firstName` through `customer.phoneNumber`, pre-filled by AJAX.
- **Button:** `input[value='Update Profile']`.
- **Empty first name:** **First name is required.**
- **Success:** heading **Profile Updated**, text **Your updated address and phone number have been added to the system.**

### Request Loan: `requestloan.htm`

| Element | Locator |
|---|---|
| Loan amount | `#amount` |
| Down payment | `#downPayment` |
| From account | `#fromAccountId` |
| Button | `input[value='Apply Now']` |

| Scenario | Result |
|---|---|
| Approved (e.g. amount 100, down payment 10) | Heading **Loan Request Processed**, provider *Wealth Securities Dynamic Loans (WSDL)*, Status **Approved**, **Congratulations, your loan has been approved.**, plus a new account number |
| Denied (e.g. amount 1,000,000) | Status **Denied**, **We cannot grant a loan in that amount with your available funds.** |

---

## Messages still to confirm

The feature files expect these messages, but they weren't recorded while exploring the site. The scenarios that use them are tagged `@needs_clarification`. Check each one on the live site, then move it to its page's section above, or correct the scenario.

| Page | Situation | Expected message | Scenario |
|---|---|---|---|
| Bill Pay | Non-numeric account number | Please enter a valid number. | TC_BILL_07 |
| Find Transactions | Bad or empty date | Invalid date format | TC_FIND_06, TC_FIND_09 |
| Find Transactions | Bad or empty transaction ID | Invalid transaction ID | TC_FIND_06 |
| Account Activity | Account ID that doesn't exist | Could not find account # &lt;id&gt; | TC_SEC_04 |
| Request Loan | Down payment above the balance | You do not have sufficient funds for the given down payment. | TC_LOAN_06 |
| Customer Care | Message sent | Thank you &lt;name&gt; / A Customer Care Representative will be contacting you. | TC_PUB_02 |
| About Us | Page text | ParaBank is a demo site used for demonstration of Parasoft software solutions. | TC_PUB_03 |