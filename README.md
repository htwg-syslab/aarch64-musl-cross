# aarch64-musl-cross

Vorkompilierte GCC+musl-Cross-Toolchain mit **aarch64-Host** und **aarch64-Target**, gebaut aus [musl-cross-make](https://github.com/richfelker/musl-cross-make) auf GitHub-Actions-Runner `ubuntu-24.04-arm`.

## Warum dieses Repo

[Bootlin](https://toolchains.bootlin.com/) liefert `aarch64--musl--stable`-Toolchains ausschliesslich mit **x86_64-Host**. Fuer ARM64-gehostete Container (Apple Silicon, AWS Graviton, GitHub `ubuntu-24.04-arm`) gibt es Stand 2026 keine fertig-vorkompilierte, signierte, aktive musl-Cross-Toolchain als Tarball.

Dieses Repo schliesst die Luecke: ein GitHub-Actions-Workflow baut auf Tag-Push einen Tarball und publisht ihn als Release-Asset mit SHA256-Checksum.

## Konsumenten

- [`htwg-syslab/container`](https://github.com/htwg-syslab/container) — esyslab-Image, ARM64-Variante. Host-Toolchain fuer HW3-Buildroot-Builds im Embedded-Systems-Kurs.

## Installation im Dockerfile

Folgt dem Muster der Bootlin-amd64-Integration:

```dockerfile
ARG AARCH64_MUSL_VERSION=2026.04-1
ARG AARCH64_MUSL_SHA256=<aus-release-asset-sha256>
RUN dpkgArch="$(dpkg --print-architecture)"; \
    if [ "$dpkgArch" = "arm64" ]; then \
        cd /opt && \
        wget -q "https://github.com/htwg-syslab/aarch64-musl-cross/releases/download/v${AARCH64_MUSL_VERSION}/aarch64--musl--stable-${AARCH64_MUSL_VERSION}.tar.xz" -O mc.tar.xz && \
        echo "${AARCH64_MUSL_SHA256}  mc.tar.xz" | sha256sum -c - && \
        mkdir -p cross && tar xJf mc.tar.xz -C cross && rm mc.tar.xz; \
    fi
ENV AARCH64_MUSL_PATH=/opt/cross/aarch64--musl--stable-2026.04-1
```

## Buildroot-Integration

`BR2_TOOLCHAIN_EXTERNAL_CUSTOM`-Einbindung:

```
BR2_TOOLCHAIN_EXTERNAL=y
BR2_TOOLCHAIN_EXTERNAL_CUSTOM=y
BR2_TOOLCHAIN_EXTERNAL_PATH="/opt/cross/aarch64--musl--stable-2026.04-1"
BR2_TOOLCHAIN_EXTERNAL_CUSTOM_PREFIX="aarch64-linux-musl"
BR2_TOOLCHAIN_EXTERNAL_CUSTOM_MUSL=y
BR2_TOOLCHAIN_EXTERNAL_CXX=y
```

`BR2_TOOLCHAIN_EXTERNAL_GCC_*` und `BR2_TOOLCHAIN_EXTERNAL_HEADERS_*` nach Release-Notes setzen — versionen ergeben sich aus `config.mak` bzw. musl-cross-make-Defaults zum Build-Zeitpunkt.

**Prefix-Hinweis**: Bootlin nutzt `aarch64-buildroot-linux-musl`, musl-cross-make `aarch64-linux-musl`. Unterschiedlicher Prefix, sonst gleiche Funktionalitaet.

## Release-Prozess

Tag-Push triggert den Build:

```bash
git tag v2026.04-1
git push origin v2026.04-1
```

Workflow laeuft auf `ubuntu-24.04-arm`, baut musl-cross-make (~20-30 min cold), erstellt Tarball + SHA256, pusht als GitHub-Release-Asset.

Versionsschema `vYYYY.MM-N` orientiert sich an Bootlin.

## Konfiguration

`config.mak` pinnt Toolchain-Versionen fuer Reproduzierbarkeit. Aenderungen an `config.mak` brauchen einen neuen Tag.

## Lizenz

Quellcode dieses Repos: MIT.

Die **gebauten Artefakte** enthalten Code unter verschiedenen Lizenzen:
- musl — MIT
- GCC — GPL-3 mit GCC Runtime Library Exception
- binutils — GPL-3
- Linux Kernel Headers — GPL-2 mit syscall-note Exception
- GMP / MPC / MPFR — LGPL-3

Siehe musl-cross-make und Upstream-Projekte fuer Details.
