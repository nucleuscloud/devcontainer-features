#!/bin/bash -i

VERSION="${VERSION:-"latest"}"
ORG="sqlc-dev"
REPO="sqlc"

set -e

binary_names="sqlc"

source ./library_scripts.sh

# nanolayer is a cli utility which keeps container layers as small as possible
# source code: https://github.com/devcontainers-contrib/nanolayer
# `ensure_nanolayer` is a bash function that will find any existing nanolayer installations,
# and if missing - will download a temporary copy that automatically get deleted at the end
# of the script
ensure_nanolayer nanolayer_location "v0.5.3"

# fetch latest version if needed
if [ "${VERSION}" = "latest" ]; then
    tag=$(curl -s https://api.github.com/repos/$ORG/$REPO/releases/latest | jq -r .tag_name)
    export VERSION="${tag:1}"
fi

$nanolayer_location \
    install \
    devcontainer-feature \
    "ghcr.io/devcontainers-contrib/features/gh-release:1.0.21" \
        --option repo='sqlc-dev/sqlc' \
        --option binaryNames="$binary_names" \
        --option version="$VERSION" \
        --option assetRegex='.*\.tar\.gz' \
        --option libName='sqlc'



echo 'Done!'
