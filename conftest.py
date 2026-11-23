import pytest


@pytest.fixture(scope="session")
def browser_context_args(browser_context_args):
    """Default options applied to every browser context."""
    return {
        **browser_context_args,
        "viewport": {"width": 1280, "height": 720},
    }
