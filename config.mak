# musl-cross-make Konfiguration fuer htwg-syslab/aarch64-musl-cross.
#
# Target: aarch64-linux-musl (Host = Build = Target; native auf ARM64-Runner)
# C++ Support aktiviert, damit BR2_TOOLCHAIN_EXTERNAL_CXX=y in Buildroot greift.
#
# Versionen NICHT hart gepinnt — musl-cross-make waehlt zum Build-Zeitpunkt
# getestete Defaults. Reproduzierbarkeit der Release-Artefakte erfolgt via
# git-tag + SHA256 des Tarballs, nicht via Rebuild-from-Source.
#
# Wenn ein bestimmter Stack doch gepinnt werden muss (z.B. weil Buildroot
# nur bis GCC_VERSION=X unterstuetzt), hier untensehen:
#   GCC_VER     = 15.2.0
#   MUSL_VER    = 1.2.5
#   BINUTILS_VER = 2.44
#   LINUX_VER   = 6.12.47
#
# Aenderungen an diesem File brauchen einen neuen git-tag + Release.

TARGET = aarch64-linux-musl

COMMON_CONFIG += --enable-languages=c,c++
COMMON_CONFIG += --disable-nls

GCC_CONFIG += --enable-default-pie
