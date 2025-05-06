"""Tests for the Draw.io export API endpoints."""

import os

from fastapi.testclient import TestClient

from drawio_export_api.main import app

client = TestClient(app)


def test_read_main():
    """Test the protected endpoint by converting a Draw.io file to SVG."""

    with open("tests/images/image.drawio", "rb") as file_to_send:

        response = client.post(
            "/svg",
            headers={
                "Authorization": f"Bearer {os.environ.get("DRAWIO_EXPORT_API_TOKEN")}"
            },
            files={"file": ("image.drawio", file_to_send, "application/xml")},
        )

        assert response.status_code == 200
        received_svg_str = response.content.decode("utf-8")
        with open("tests/images/image.svg", encoding="utf-8") as file_to_expect:
            expected_svg_str = file_to_expect.read()
            assert received_svg_str.strip() == expected_svg_str.strip()
