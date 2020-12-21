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

## Scripts

### validate-shell-scripts.sh

`validate-shell-scripts.sh` attempts to validate every shell script in the working directory and subdirectories.

Set the optional `--expect` argument to have the script fail if any more or fewer are found than you expect.

For example, to just validate all the scripts:

```bash
validate-shell-scripts.sh
```

To fail if greater or fewer than three scripts are found:

```bash
validate-shell-scripts.sh --expect 3
```

## Usage in GitHub Actions

The following configuration demonstrates how to use `cariad/ci:1.0.0` to:

1. Use `pipenv` to create a Python virtual environment and run a script.
1. Use `hadolint` to lint a Dockerfile.
1. Use `validate-shell-scripts` to lint all the shell scripts.

```yaml
jobs:
  validate:
    container: cariad/ci:1.0.0
    runs-on: ubuntu-latest
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
        run: validate-shell-scripts.sh
```

## FAQs

### How do I fix "<botocore.awsrequest.AWSRequest object at 0x7fbfdd919f60>" when I run "aws"?

`aws` gets upset when a default region isn't set and it can't hit the EC2 metadata service to figure out where it is.

Set these two environment variables in your CI pipeline:

1. `AWS_DEFAULT_REGION=<your region>`
1. `AWS_EC2_METADATA_DISABLED=true`

### How do I set AWS credentials for the container to use?

In GitHub Actions:

1. Create secrets named `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` in your GitHub repository, and set their values to your credentials.
1. Add these environment variables to your workflow:

```yaml
env:
  AWS_ACCESS_KEY_ID:     ${{ secrets.AWS_ACCESS_KEY_ID }}
  AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```
