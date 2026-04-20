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

# Compiler + Debugger-Versionen matchend Bootlin 2024.02-1
GCC_VER = 12.3.0
GDB_VER = 13.2

COMMON_CONFIG += --enable-languages=c,c++
COMMON_CONFIG += --disable-nls

GCC_CONFIG += --enable-default-pie
