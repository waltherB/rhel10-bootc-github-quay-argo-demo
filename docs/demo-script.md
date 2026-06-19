# Demo script

## 1. Show repo

- Containerfile
- GitHub Actions workflow
- Quay target image
- Argo CD application

## 2. Local build on Mac M4

```bash
export IMAGE=quay.io/waba/rhel10-bootc-demo:dev
export TARGET_PLATFORM=linux/arm64
./scripts/local-build.sh
./scripts/local-test.sh
./scripts/local-push.sh
./scripts/local-sign-keyless.sh
```

## 3. Build qcow2

```bash
podman machine stop
podman machine set --rootful
podman machine start
./scripts/local-qcow2.sh
```

Import `output/qcow2/disk.qcow2` into UTM.

## 4. Boot and verify

```bash
bootc status
cat /etc/motd
curl http://localhost
```

## 5. GitHub Actions CI

Push commit to GitHub and show workflow:

- build
- smoke test
- push to Quay
- cosign sign
- cosign verify

## 6. Promote

Run `promote-rhel10-bootc-prod` workflow manually.

## 7. VM update

```bash
sudo bootc switch --apply quay.io/waba/rhel10-bootc-demo:prod
```

## 8. Rollback

```bash
sudo bootc rollback
sudo systemctl reboot
```
