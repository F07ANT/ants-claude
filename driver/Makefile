# Build with WDK command prompt:
#   cd driver && nmake
#
# Requires: WDK 10/11 installed, run from "x64 Native Tools Command Prompt"
# with WDK environment (set KMDF_INC_PATH, etc.)
#
# Or use the .inf + VS driver project — this Makefile is for quick iteration.

TARGETNAME = r6drv
TARGETTYPE = DRIVER

SOURCES = main.c memory.c process.c clean.c

# ──── WDK nmake (manual) ────
# If building outside Visual Studio:
#
# cl /nologo /kernel /W4 /WX /Zi /Oi /GS- /Gs999999 \
#    /D_AMD64_ /DAMD64 /D_WIN64 /DNTDDI_VERSION=0x0A000007 \
#    /I"$(WDK_INC)\km" /I"$(WDK_INC)\shared" /I"..\include\shared" \
#    /c main.c memory.c process.c clean.c
#
# link /nologo /DRIVER /SUBSYSTEM:NATIVE /ENTRY:DriverEntry \
#      /LIBPATH:"$(WDK_LIB)\km\x64" \
#      ntoskrnl.lib hal.lib wdmsec.lib \
#      /OUT:r6drv.sys \
#      main.obj memory.obj process.obj clean.obj
#
# FILL: set WDK_INC and WDK_LIB to your WDK paths, e.g.:
#   set WDK_INC=C:\Program Files (x86)\Windows Kits\10\Include\10.0.22621.0
#   set WDK_LIB=C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0
