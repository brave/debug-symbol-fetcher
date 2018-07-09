#!/usr/bin/env bash
set -eux

MUON_URL="https://github.com/brave/electron/releases/download"
CORE_URL="https://github.com/brave/brave-browser-builds/releases/download"

MUON_VERSIONS="${MUON_VERSIONS:-}"
CORE_VERSIONS="${CORE_VERSIONS:-}"

if [ -z "$MUON_VERSIONS" ] && [ -z "$CORE_VERSIONS" ]; then
    echo "Error, missing MUON_VERSIONS or CORE_VERSIONS environment variables. Please set."
    exit 1
fi

echo $CORE_URL

for VERSION in $MUON_VERSIONS
do
    # shellcheck disable=SC2086
    mkdir -p symbols/{win32-ia32-$VERSION,win32-x64-$VERSION,darwin-$VERSION,linux-$VERSION}

    if [ "$(which bsdtar)" ] && [ ! "$FORCE_UNZIP" ]; then
        cmd="bsdtar -xvf-"
        ( cd "symbols/win32-ia32-$VERSION" ; wget -O - "$MUON_URL/v${VERSION}/brave-v${VERSION}-win32-ia32-symbols.zip" | $cmd )
        ( cd "symbols/win32-x64-$VERSION" ; wget -O - "$MUON_URL/v${VERSION}/brave-v${VERSION}-win32-x64-symbols.zip" | $cmd )
        ( cd "symbols/darwin-$VERSION" ; wget -O - "$MUON_URL/v${VERSION}/brave-v${VERSION}-darwin-x64-symbols.zip" | $cmd )
    elif [ "$(which unzip)" ]; then
        cmd="unzip -x"
        ( cd "symbols/win32-ia32-$VERSION" ; wget -O - "$MUON_URL/v${VERSION}/brave-v${VERSION}-win32-ia32-symbols.zip" > /tmp/win32-ia32.zip ; $cmd /tmp/win32-ia32.zip ; rm /tmp/win32-ia32.zip)
        ( cd "symbols/win32-x64-$VERSION" ; wget -O - "$MUON_URL/v${VERSION}/brave-v${VERSION}-win32-x64-symbols.zip" > /tmp/win32-x64.zip ; $cmd /tmp/win32-x64.zip ; rm /tmp/win32-x64.zip)
        ( cd "symbols/darwin-$VERSION" ; wget -O - "$MUON_URL/v${VERSION}/brave-v${VERSION}-darwin-x64-symbols.zip" > /tmp/darwin.zip ; $cmd /tmp/darwin.zip ; rm /tmp/darwin.zip)
    fi
done

for VERSION in $CORE_VERSIONS
do
    # shellcheck disable=SC2086
    mkdir -p symbols/{win32-ia32-$VERSION,win32-x64-$VERSION,darwin-$VERSION,linux-$VERSION}
    if [ "$(which bsdtar)" ] && [ ! "$FORCE_UNZIP" ]; then
        cmd="bsdtar -xvf-"
        ( cd "symbols/win32-x64-$VERSION" ; wget -O - "$CORE_URL/v${VERSION}/brave-v${VERSION}-win32-x64-symbols.zip" | $cmd )
        ( cd "symbols/darwin-$VERSION" ; wget -O - "$CORE_URL/v${VERSION}/brave-v${VERSION}-darwin-x64-symbols.zip" | $cmd )
    elif [ "$(which unzip)" ]; then
        cmd="unzip -x"
        ( cd "symbols/win32-x64-$VERSION" ; wget -O - "$CORE_URL/v${VERSION}/brave-v${VERSION}-win32-x64-symbols.zip" > /tmp/win32-x64.zip ; $cmd /tmp/win32-x64.zip ; rm /tmp/win32-x64.zip)
        ( cd "symbols/darwin-$VERSION" ; wget -O - "$CORE_URL/v${VERSION}/brave-v${VERSION}-darwin-x64-symbols.zip" > /tmp/darwin.zip ; $cmd /tmp/darwin.zip ; rm /tmp/darwin.zip)
    fi
done
