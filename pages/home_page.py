from playwright.sync_api import Page


class HomePage:
    def __init__(self, page: Page):
        self.page = page
        self.get_started_link = page.get_by_role("link", name="Get started")

    def open(self):
        self.page.goto("/")
