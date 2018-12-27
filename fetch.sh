#!/usr/bin/env bash
set -eux

if [ ! -f "$(which bsdtar)" -a ! -f "$(which unzip)" ]; then
    echo "Cannot find either bsdtar or unzip commands, at least 1 must be installed, exiting..."
    exit 1
fi

CORE_URL="https://github.com/brave/brave-browser/releases/download"

CORE_VERSIONS="${CORE_VERSIONS:-$(curl -s https://api.github.com/repos/brave/brave-browser/releases| jq .[].tag_name| sed 's/^"v//g; s/"$//g')}"

FORCE_UNZIP="${FORCE_UNZIP:-}"

for VERSION in $CORE_VERSIONS
do
    # shellcheck disable=SC2086
    mkdir -p symbols/{win32-ia32-$VERSION,win32-x64-$VERSION,darwin-$VERSION,linux-$VERSION}
    if [ "$(which bsdtar)" ] && [ ! "$FORCE_UNZIP" ]; then
        cmd="bsdtar -xvf-"
        test -f "symbols/win32-x64-$VERSION/LICENSE" || ( cd "symbols/win32-x64-$VERSION" ; wget -O - "$CORE_URL/v${VERSION}/brave-v${VERSION}-win32-x64-symbols.zip" | $cmd )
        test -f "symbols/darwin-$VERSION/LICENSE" || ( cd "symbols/darwin-$VERSION" ; wget -O - "$CORE_URL/v${VERSION}/brave-v${VERSION}-darwin-x64-symbols.zip" | $cmd )
        test -f "symbols/linux-$VERSION/LICENSE" || ( cd "symbols/linux-$VERSION" ; wget -O - "$CORE_URL/v${VERSION}/brave-v${VERSION}-linux-x64-symbols.zip" | $cmd )
    elif [ "$(which unzip)" ]; then
        cmd="unzip -x"
        test -f "symbols/win32-x64-$VERSION/LICENSE" || ( cd "symbols/win32-x64-$VERSION" ; wget -O - "$CORE_URL/v${VERSION}/brave-v${VERSION}-win32-x64-symbols.zip" > /tmp/win32-x64.zip ; $cmd /tmp/win32-x64.zip ; rm /tmp/win32-x64.zip)
        test -f "symbols/darwin-$VERSION/LICENSE" || ( cd "symbols/darwin-$VERSION" ; wget -O - "$CORE_URL/v${VERSION}/brave-v${VERSION}-darwin-x64-symbols.zip" > /tmp/darwin.zip ; $cmd /tmp/darwin.zip ; rm /tmp/darwin.zip)
        test -f "symbols/linux-$VERSION/LICENSE" || ( cd "symbols/linux-$VERSION" ; wget -O - "$CORE_URL/v${VERSION}/brave-v${VERSION}-linux-x64-symbols.zip" > /tmp/linux.zip ; $cmd /tmp/linux.zip ; rm /tmp/linux.zip)
    fi
done
