# Draw.io Export API

[![Development Status](https://img.shields.io/badge/status-beta-yellow.svg)](https://github.com/rautanen-io/drawio-export-api)

A simple API server that converts Draw.io diagram files to SVG format.

> **Note**: This application is currently in beta release. While core functionality is operational, certain features remain under active development. The system may experience intermittent stability issues, particularly when processing malformed `.drawio` files.

## Why do we need this?

**Network Documentation Automation**. Primarily created to generate dynamic network diagrams from [Netbox](https://github.com/netbox-community/netbox) data, it's used by the [Netbox Ninja Plugin](https://github.com/rautanen-io/netbox-ninja-plugin) to automatically create and update network documentation. Perhaps it can be useful in some other context too.

## Overview

This service provides a REST API endpoint that accepts [Draw.io](https://www.drawio.com) (.drawio) files and returns them converted to SVG format. It can be used for automated documentation workflows or with systems that needs to render Draw.io diagrams as SVGs.

In practice, the implementation brings together the following components:
- [drawio-export](https://github.com/rlespinasse/drawio-export) Docker image
- Minimal [FastAPI](https://fastapi.tiangolo.com) server
- [Nginx](https://nginx.org) for HTTPs

## Features

- Convert Draw.io files to SVG format
- RESTful API interface
- Docker-based deployment
- Authentication support
- Headless Draw.io desktop for reliable conversions

## Prerequisites

- Docker and Docker Compose
- Make (optional, for using Makefile commands)

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/rautanen-companies/drawio-export-api.git
   cd drawio-export-api
   ```

2. Build and start the service (without TLS):
   ```bash
   make up
   ```

   Alternatively start the service with TLS enabled:
   ```bash
   make prod-up
   ```

## Usage

### API Endpoint

Send a POST request to `/convert` with:

- The .drawio file in the request body
- Authorization header with your API token

Example using curl:
```bash
curl -X POST \
  -H "Authorization: Bearer your-token-here" \
  -H "Content-Type: application/octet-stream" \
  --data-binary @your-diagram.drawio \
  http://localhost:8000/convert > output.svg
```

Token can be set in `dev.env` and `prod.env` files.

### Using the Python Client

The project includes a simple Python client that makes it possible to interact with the API. You can use it like this:

```python
python src/drawio_export_api_client/client.py \
    http://localhost:8000/svg \
    your-token-here \
    path/to/your/diagram.drawio
```

For HTTPS endpoints, you'll need to provide a certificate path:
```python
python src/drawio_export_api_client/client.py \
    https://localhost:443/svg \
    your-token-here \
    path/to/your/diagram.drawio
    path/to/certificate.pem
```

The client provides:
- Simple interface for API interaction
- Built-in error handling
- HTTPS support with certificate verification
- Command-line and programmatic usage options

### Response

The API returns:
- 200 OK with the SVG content on successful conversion
- 400 Bad Request if the input file is invalid
- 401 Unauthorized if the authentication token is missing or invalid
- 500 Internal Server Error if the conversion fails

## Known Issues and Limitations

1. Single Page Export
   - Currently only exports the first page (Page-1) of multi-page diagrams
   - No support for selecting specific pages to export

2. Format Support
   - Only supports SVG export format
   - No support for PNG, PDF, or other export formats
   - No control over SVG export options (like scale, background color)

3. Error Handling
   - Limited error messages for malformed Draw.io files
   - No detailed feedback on conversion failures

4. Performance
   - Single-threaded processing
   - No request queuing for high-load scenarios
   - Each conversion starts a new Draw.io instance

## Features to do

1. Enhanced Export Options
   - [ ] Support for multiple page export
   - [ ] Additional export formats (PNG, PDF)

2. Performance Improvements
   - [ ] Request queuing system

3. Enhanced Security
   - [ ] Rate limiting
   - [ ] API key management interface

5. Monitoring and Logging
   - [ ] Health check endpoint
   - [ ] Detailed error logging

## Development

For development setup and guidelines, please refer to our [Contributing Guidelines](CONTRIBUTING.md).

## Configuration

Configuration is done through environment variables:

- `AUTH_TOKEN`: API authentication token
- `PORT`: Server port (default: 8000)
- Additional configuration can be set in `docker-compose.override.yml`

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Security

Please do not commit any sensitive information such as API tokens. Use environment variables for sensitive data.

## Thanks
This project builds on top of [drawio-export](https://github.com/rlespinasse/drawio-export). Thanks goes to https://github.com/rlespinasse!
