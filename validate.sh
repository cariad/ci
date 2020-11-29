#!/bin/bash -e

echo "Linting scripts..."
find . -name '*.sh' -exec shellcheck -o all --severity style -x {} +

echo "Linting Dockerfile..."
hadolint

echo "Linting YAML..."
yamllint .

echo "OK!"
