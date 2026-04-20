# musl-cross-make Konfiguration fuer htwg-syslab/aarch64-musl-cross.
#
# Target: aarch64-linux-musl (Host = Build = Target; native auf ARM64-Runner)
# C++ Support aktiviert, damit BR2_TOOLCHAIN_EXTERNAL_CXX=y in Buildroot greift.
#
# Versionen gepinnt auf Bootlin-2024.02-1-Niveau, damit ein einzelnes
# Buildroot-External-Toolchain-Setup (BR2_TOOLCHAIN_EXTERNAL_GCC_12=y,
# _HEADERS_4_19=y, _CUSTOM_MUSL=y) ohne arch-spezifische Weichen beide
# Archs (amd64 via Bootlin, arm64 via diesen Build) bedient.
#
# Nicht gepinnt sind Binutils, Kernel-Headers, GMP/MPC/MPFR:
#  * Binutils 2.44 (musl-cross-make-Default) ist neuer als Bootlins 2.41 —
#    ABI-kompatibel, keine Regression.
#  * Kernel-Headers-Patchversion ist fuer Buildroots _HEADERS_4_19=y
#    transparent (Buildroot pinnt nur Major.Minor).
#  * GMP/MPC/MPFR bindet musl-cross-make intern passend zur GCC-Version.
#
# Aenderungen an diesem File brauchen einen neuen git-tag + Release.

TARGET = aarch64-linux-musl

# GCC 12.x matchend Bootlin 2024.02-1-Linie (Bootlin: 12.3.0).
# musl-cross-make hat auf master nur 12.4.0 in der 12er-Serie
# (hashes/gcc-12.4.0.tar.xz.sha1) — reine Patch-Level-Differenz, ABI-kompatibel.
GCC_VER = 12.4.0

# gdb wird von musl-cross-make nicht gebaut (kein gdb-Eintrag in Makefile
# oder hashes/). Fuer Target-Debugging im esyslab-Container steht
# `gdb-multiarch` (Ubuntu-Paket) bereit, das aarch64-Targets unterstuetzt.
# Falls ein nativer aarch64-linux-musl-gdb gewuenscht wird, waere ein
# separater Post-Build-Step im release.yml noetig — siehe Issue-Tracker.

COMMON_CONFIG += --enable-languages=c,c++
COMMON_CONFIG += --disable-nls

GCC_CONFIG += --enable-default-pie
