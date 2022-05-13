# Policy checker

This is a tool that can be used locally and in CI by tooling to determine if the repository is compliant with policy.

The version of policy is determined by:
 - Kubernetes: reads the `kustomization.yaml` file and retrieves the `commonLabels['mycompany.com/policy-version']`
 - Terraform: reads the variable default_value of `mycompany.com/policy-version`

If theres any `.tf` files it'll check terraform and check Kubernetes if theres a `kustomization.yaml`.

## ⚠️⚠️ This is not intended for general use or to be immediately reusable ⚠️⚠️
The location of the policy it retrieves is hardcoded to get from [policy-as-versioned-code/policy](https://github.com/policy-as-versioned-code/policy). This was a very conscious limitation to scope this to the proof of concept of the [policy-as-versioned-code GitHub org](https://github.com/policy-as-versioned-code), to make this more reusable it needs to handle authenticating to retrieve the policy where it's in a private repo, be a significantly smaller image, cache the policy so it doesn't need to be retrieved on every execution and find a better story than docker to be able to execute locally for the sake of speed.

## Usage

```bash
$ docker run --rm -v $(pwd):/apps ghcr.io/policy-as-versioned-code/policy-checker
```