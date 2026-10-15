"""Check which browser origins may call the API."""

import unittest

from fastapi.testclient import TestClient

from app.main import app

ALLOWED = [
    "https://lagaw.pages.dev",
    "https://chore-some-branch.lagaw.pages.dev",
    "https://88999afd.lagaw.pages.dev",
    "http://localhost:5000",
    "http://127.0.0.1:8080",
]
DENIED = [
    "https://evil.example",
    "https://lagaw.pages.dev.evil.example",
    "https://notlagaw.pages.dev",
    "http://lagaw.pages.dev",
]


class CorsTests(unittest.TestCase):
    def setUp(self):
        self.client = TestClient(app)
        self.addCleanup(self.client.close)

    def preflight(self, origin):
        return self.client.options(
            "/locations",
            headers={"Origin": origin, "Access-Control-Request-Method": "GET"},
        )

    def test_frontend_origins_are_allowed(self):
        for origin in ALLOWED:
            with self.subTest(origin=origin):
                response = self.preflight(origin)
                self.assertEqual(response.status_code, 200)
                self.assertEqual(response.headers["access-control-allow-origin"], origin)

    def test_other_origins_are_rejected(self):
        for origin in DENIED:
            with self.subTest(origin=origin):
                response = self.preflight(origin)
                self.assertNotIn("access-control-allow-origin", response.headers)

    def test_only_reads_are_allowed(self):
        response = self.client.options(
            "/locations",
            headers={"Origin": "https://lagaw.pages.dev", "Access-Control-Request-Method": "DELETE"},
        )
        self.assertEqual(response.status_code, 400)


if __name__ == "__main__":
    unittest.main()
