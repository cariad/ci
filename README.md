# cariad/ci

A Docker image for all my CI/CD needs, and maybe yours too.

## What's included?

`cariad/ci` is based on `ubuntu:20.04` and includes:

- `aws`
- `hadolint`
- `pipenv`
- `pyenv`
- `python` (3.9.0)
- `shellcheck`

## Example usage

### GitHub Actions

This GitHub Actions configuration demonstrates how to use `cariad/ci:1.0.0` to:

1. Use `pipenv` to create a Python virtual environment and run a script.
1. Use `hadolint` to lint a Dockerfile.
1. Use `shellcheck` to lint a shell script.

```yaml
jobs:
  validate:
    runs-on: ubuntu-latest
    container: cariad/ci:1.0.0
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Lint YAML
        run: |
          pipenv sync --dev
          pipenv run yamllint .

      - name: Lint Dockerfile
        run: hadolint Dockerfile

      - name: Lint scripts
        run: shellcheck entry.sh
```

## Building and running locally

```bash
./validate.sh
docker build --tag cariad/ci .
docker run -it --rm cariad/ci
```
