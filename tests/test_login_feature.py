import re
from playwright.sync_api import Page, expect

from pages.home_page import HomePage


def test_homepage_has_title(page: Page):
    home = HomePage(page)
    home.open()
    expect(page).to_have_title(re.compile("ParaBank"))


def test_homepage_has_text(page: Page):
    home = HomePage(page)
    home.open()
    expect(page.get_by_text("Customer Login")).to_be_visible()


def test_login_successful(page: Page):
    home = HomePage(page)
    home.open()
    username = page.locator("input[name='username']")
    username.fill("Andres")
    expect(username).to_have_value("Andres")
    password = page.locator("input[name='password']")
    password.fill("ABCD1234")
    login_button = page.get_by_role("button", name=re.compile("LOG IN", re.IGNORECASE))
    login_button.click()
    expect(page.get_by_text("Welcome", exact=True)).to_be_visible()
