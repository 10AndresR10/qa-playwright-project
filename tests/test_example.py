import re

from playwright.sync_api import Page, expect

from pages.home_page import HomePage


def test_has_title(page: Page):
    home = HomePage(page)
    home.open()
    expect(page).to_have_title(re.compile("Playwright"))


def test_get_started_link(page: Page):
    home = HomePage(page)
    home.open()
    home.get_started_link.click()
    expect(page.get_by_role("heading", name="Installation")).to_be_visible()
