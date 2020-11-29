# ci

A Docker image for all my CI/CD needs, and maybe yours too.

## What's included?

`cariad/ci` is based on `ubuntu:20.04` and includes:

- `aws`
- `hadolint`
- `pipenv`
- `pyenv`
- `python` (3.9.0)
- `shellcheck`

## Building and running locally

```bash
./validate.sh
docker build --tag cariad/ci .
docker run -it --rm cariad/ci
```
