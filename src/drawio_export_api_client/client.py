"""Example client to call the API."""

import sys
from urllib.parse import urlparse

import requests


def print_help():
    """Prints the help message."""
    help_message = """
    Usage: python client.py <url> <token> <drawio_file_path> [<cert_path>]

    Arguments:
        url: The URL of the Draw.io Export API endpoint
        token: The API authentication token
        drawio_file_path: Path to the Draw.io file to convert
        cert_path: Path to SSL certificate for HTTPS URLs (required for HTTPS)

    Example usage:
        python src/drawio_export_api_client/client.py \
            http://localhost:8000/svg \
            token1 \
            tests/images/image.drawio
        python src/drawio_export_api_client/client.py \
            https://localhost:443/svg \
            token1 \
            tests/images/image.drawio \
            nginx/certs/fullchain.pem
    """
    print(help_message)


def convert_drawio_to_svg(
    url: str = None,
    token: str = None,
    drawio_file_path: str = None,
    cert_path: str = None,
) -> str:
    """Convert a Draw.io file to SVG using the Draw.io Export API.

    Args:
        url: The URL of the Draw.io Export API endpoint
        token: The API authentication token
        drawio_file_path: Path to the Draw.io file to convert
        cert_path: Path to SSL certificate for HTTPS URLs (required for HTTPS)

    Returns:
        The converted SVG as a string

    Raises:
        ValueError: If cert_path is not provided for HTTPS URLs
        requests.exceptions.RequestException: If the API request fails
    """
    if not all([url, token, drawio_file_path]):
        print_help()
        sys.exit(1)

    # Validate HTTPS requires cert
    parsed_url = urlparse(url)
    if parsed_url.scheme == "https" and not cert_path:
        raise ValueError("Certificate path required for HTTPS URLs")

    # Prepare request
    with open(drawio_file_path, "rb") as xml_file:
        files = {"file": ("image.drawio", xml_file, "application/xml")}
        headers = {"Authorization": f"Bearer {token}"}

        verify = cert_path if parsed_url.scheme == "https" else None

        # Make request
        response = requests.post(
            url, files=files, headers=headers, verify=verify, timeout=360
        )

        response.raise_for_status()
        return response.content.decode("utf-8")


if __name__ == "__main__":
    # Assuming the script is run with arguments
    if len(sys.argv) < 4:
        print_help()
        sys.exit(1)

    api_url = sys.argv[1]
    api_token = sys.argv[2]
    input_file_path = sys.argv[3]
    ssl_cert_path = sys.argv[4] if len(sys.argv) > 4 else None

    # Call the function with arguments
    print(convert_drawio_to_svg(api_url, api_token, input_file_path, ssl_cert_path))
