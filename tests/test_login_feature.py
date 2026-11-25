import re
from playwright.sync_api import Page, expect


def test_homepage_has_title(page:Page):
    page.goto("https://parabank.parasoft.com/")
    expect(page).to_have_title(re.compile("ParaBank"))
