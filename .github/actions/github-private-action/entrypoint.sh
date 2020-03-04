#!/bin/sh
##############################################################
# entrypoint.sh
#
set -e

package=$1
directory=$2
token=$3

usage() {
  echo "entrypoint.sh package directory token"
  echo "  package - Github package name"
  echo "  directory - directory to install package"
  echo "  token - Github Access Token with permissions for Github Packages"
}

test_param() {
  name=$1
  param=$2
  if test -z "${param}"; then
    echo "ERROR: Missing arg ${name}"
    usage
    exit 1
  fi
}

test_param "package" "${package}"
test_param "directory" "${directory}"
test_param "token" "${token}"

# ------------ #

install_directory=${GITHUB_WORKSPACE}/${directory}

GITHUB_PACKAGE_TOKEN=${token}
export GITHUB_PACKAGE_TOKEN

cd /tmp
npm config set '//npm.pkg.github.com/:_authToken' '${GITHUB_PACKAGE_TOKEN}'
npm config set '@wpmedia:registry' 'https://npm.pkg.github.com'

npm install ${package}

mkdir -p ${install_directory}
cp -R node_modules/* ${install_directory}
