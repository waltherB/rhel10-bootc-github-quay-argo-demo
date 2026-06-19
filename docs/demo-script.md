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

## 7. VM update – live demo of image-based OS update

This section shows the full loop: change something visible → push → CI builds a new image → VM pulls and applies it.

### 7a. Make a visible change

Edit `files/motd` to bump the version so the update is easy to verify on the VM:

```bash
# on your Mac
echo "RHEL 10 Image Mode Demo v2 – updated $(date +%F)" > files/motd
git add files/motd
git commit -m "chore: bump motd to v2 to demo live update"
git push
```

You can also change `app/index.html` if you want a visible change in the browser.

### 7b. Watch the CI pipeline

Go to **GitHub → Actions → build-sign-push-rhel10-bootc** and watch:

1. Build the new arm64 image
2. Smoke-test the container
3. Push `:dev` tag to Quay
4. Cosign sign + verify

Once green, run the **promote-rhel10-bootc-prod** workflow manually to retag `:dev → :prod`.

### 7c. Check what the VM is running now

SSH into the VM (or open the UTM console):

```bash
# show current booted image digest, motd, and httpd
vm-status
```

Note the image digest shown under `booted` — this is the old version.

### 7d. Pull and stage the new image

```bash
# Pull new :prod image, stage it, then reboot
vm-upgrade
```

`bootc upgrade` fetches the new OCI layers and writes them to the staging deployment. The running OS is **not touched** until reboot.

### 7e. Verify after reboot

```bash
# new digest should differ from what you noted in 7c
vm-status
```



```
GitHub push
  └── Actions: build → test → push quay.io/…:dev
        └── promote workflow: skopeo copy :dev → :prod
              └── VM: bootc upgrade pulls new :prod layers
                    └── systemctl reboot → boots new deployment
                          └── old deployment kept as rollback target
```

bootc uses OSTree under the hood: the new image is a new deployment, the previous one is retained automatically.


## 8. Rollback

```bash
sudo bootc rollback
sudo systemctl reboot
```
