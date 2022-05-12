#!/bin/bash

set -e

if test -f "kustomization.yaml"; then
  echo "Found kustomization.yaml"

  echo "Checking policy version..."

  FETCHED_POLICY_VERSION=$(yq eval '.commonLabels["mycompany.com/policy-version"]' kustomization.yaml)

  POLICY_VERSION="${FETCHED_POLICY_VERSION:=$POLICY_VERSION}"

  echo "Policy version: ${POLICY_VERSION}"

  echo "Fetching Policy..."

  git clone --quiet --depth 1 --branch ${POLICY_VERSION} https://github.com/policy-as-versioned-code/policy.git /policy

  echo "Policy fetched."
  echo "Running policy checker..."

  kubectl kustomize . | kyverno apply  /policy/kubernetes/kyverno/*/policy.yaml --resource -
fi


if compgen -G "./*.tf" > /dev/null; then
  echo "Found Terraform files"

  echo "Checking policy version..."
  mkdir /tmp/tf
  cp -r * /tmp/tf
  hcl2tojson -s /tmp/tf /tmp/hcl2tojson
  
  FETCHED_POLICY_VERSION=$(jq -n '[inputs]' /tmp/hcl2tojson/*.json | jq -r 'map(select(.variable))[].variable|map(select(.["mycompany.com/policy-version"]))[0]["mycompany.com/policy-version"].default[0]') 
  POLICY_VERSION="${FETCHED_POLICY_VERSION:=$POLICY_VERSION}"

  echo "Policy version: ${POLICY_VERSION}"

  echo "Fetching Policy..."
  git clone --quiet --depth 1 --branch ${POLICY_VERSION} https://github.com/policy-as-versioned-code/policy.git /policy

  echo "Policy fetched."

  echo "Running policy checker..."
  checkov \
    --external-checks-dir /policy/infra/checkov \
    --config-file /policy/infra/checkov/config.yaml \
    --directory .
fi