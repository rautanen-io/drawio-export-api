# Contributing to Draw.io Export API

Thank you for your interest in contributing to Draw.io Export API! This document provides guidelines and instructions for contributing to the project.

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Environment](#development-environment)
- [Making Changes](#making-changes)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Code Style](#code-style)
- [Documentation](#documentation)

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to [veikko@rautanen.io](mailto:veikko@rautanen.io).

## Getting Started

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone git@github.com:your-username/drawio-export-api.git
   cd drawio-export-api
   ```
3. Add the upstream repository as a remote:
   ```bash
   git remote add upstream git@github.com:original-owner/drawio-export-api.git
   ```

## Development Environment

### Prerequisites
- Python 3.11 or higher
- Poetry (Python package manager)
- Docker and Docker Compose
- Make (optional, but recommended)

### Setting Up the Development Environment

1. Install Poetry if you haven't already:
   ```bash
   curl -sSL https://install.python-poetry.org | python3 -
   ```

2. Install project dependencies:
   ```bash
   poetry install
   ```

3. Install pre-commit hooks:
   ```bash
   poetry run pre-commit install
   ```

4. Generate SSL certificates for local development (if needed):
   ```bash
   make keys
   ```

### Development Commands

The project includes several Make commands to help with development:

- `make up`: Start the development environment
- `make down`: Stop the development environment
- `make test`: Run tests
- `make lint`: Run linting checks
- `make build`: Build Docker images
- `make restart`: Restart the development environment
- `make bash`: Open a shell in the web container

## Making Changes

1. Create a new branch for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes, following our [Code Style](#code-style) guidelines

3. Commit your changes:
   ```bash
   git add .
   git commit -m "Description of your changes"
   ```

## Testing

### Running Tests

Run the test suite using:
```bash
make test
```

### Writing Tests

- Place tests in the `tests/` directory
- Name test files with `test_` prefix
- Use pytest for writing tests
- Include both unit tests and integration tests where appropriate
- Aim for high test coverage for new features

## Code Style

This project uses several tools to maintain code quality:

1. **Black** for code formatting:
   ```bash
   poetry run black .
   ```

2. **isort** for import sorting:
   ```bash
   poetry run isort .
   ```

3. **flake8** for linting:
   ```bash
   poetry run flake8
   ```

Pre-commit hooks will automatically check these when you commit changes.

### Code Style Guidelines

- Follow PEP 8 conventions
- Use type hints for function arguments and return values
- Write docstrings for all public functions and classes
- Keep functions focused and single-purpose
- Use meaningful variable and function names

## Documentation

### API Documentation

- Document all API endpoints with FastAPI docstrings
- Include request/response examples
- Document all parameters and return values

### Code Documentation

- Write clear docstrings for all public functions and classes
- Include usage examples in docstrings where helpful
- Keep comments current when modifying code
- Document complex algorithms and business logic

## Submitting Changes

1. Push your changes to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

2. Create a Pull Request (PR) on GitHub

3. In your PR description:
   - Describe the changes
   - Link to any related issues
   - Note any breaking changes
   - Include steps to test the changes

4. Wait for review and address any feedback

### Pull Request Checklist

Before submitting a PR, ensure:

- [ ] All tests pass
- [ ] Code is formatted with Black
- [ ] Imports are sorted with isort
- [ ] No flake8 warnings
- [ ] Documentation is updated
- [ ] Changes are tested
- [ ] Commit messages are clear and descriptive
- [ ] Branch is up to date with main

## Questions or Problems?

If you have questions or run into problems, please:

1. Check existing issues on GitHub
2. Create a new issue if needed
3. Ask questions in the PR or issue

Thank you for contributing to Draw.io Export API!
