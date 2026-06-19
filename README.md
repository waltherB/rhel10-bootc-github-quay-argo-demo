# RHEL 10 Image Mode Demo – GitHub Actions + Quay + Argo CD

Demo repo for building, signing and deploying a RHEL 10 bootc / Image Mode image.

Target setup:

- MacBook Pro M4
- Podman + Podman Desktop
- UTM for RHEL 10 VMs
- Quay.io as image registry
- GitHub as source repo and CI
- Argo CD as GitOps CD for Kubernetes/MicroShift workloads

> Important: replace `quay.io/waba/rhel10-bootc-demo` with your actual Quay namespace/repository.
> Quay image references use `quay.io/<namespace>/<repository>:<tag>`. Your email may be your login identity, but not necessarily the namespace in the image reference.

## Quick local flow

```bash
podman login registry.redhat.io
podman login quay.io

export IMAGE=quay.io/waba/rhel10-bootc-demo:dev

./scripts/local-build.sh
./scripts/local-test.sh
./scripts/local-push.sh
./scripts/local-sign-keyless.sh
./scripts/local-qcow2.sh
```

Import `output/qcow2/disk.qcow2` in UTM.

## GitHub Actions

Create these GitHub repository secrets:

- `RH_REGISTRY_USERNAME`
- `RH_REGISTRY_PASSWORD`
- `QUAY_USERNAME`
- `QUAY_TOKEN`

Create these GitHub repository variables:

- `QUAY_IMAGE=quay.io/waba/rhel10-bootc-demo`
- `TARGET_PLATFORM=linux/arm64` for Mac M4 / UTM ARM demo

For GitHub-hosted runners, Linux runners are normally x86_64. For an ARM64 image that matches a Mac M4 / UTM ARM VM, use a self-hosted ARM64 runner or build locally on the Mac.

## Argo CD note

Argo CD is Kubernetes GitOps CD. It does not directly manage a non-Kubernetes host OS by itself. In this demo repo, Argo CD is used for the app/platform layer on MicroShift/Kubernetes, while OS lifecycle is handled by bootc.

If you want Argo to orchestrate host updates, use Argo Workflows/Events or an Argo CD-managed Job that calls an update mechanism, but treat that as a demo pattern unless hardened for production.
