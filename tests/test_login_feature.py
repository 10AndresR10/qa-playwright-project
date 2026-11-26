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

def test_login_succesfull(page: Page):
    home = HomePage(page)
    home.open()
    page.locator('b:has-text("Username")')
    page.get_by_role("textbox", name="username")
