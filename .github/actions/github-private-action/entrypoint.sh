#!/bin/sh
##############################################################
# entrypoint.sh
#
set -e

package_name=$1
directory=$2
token=$3

usage() {
  echo "entrypoint.sh package_name directory token"
  echo "  package_name - Github package name"
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

test_param "package_name" "${package_name}"
test_param "directory" "${directory}"
test_param "token" "${token}"

# ------------ #

install_directory=${GITHUB_WORKSPACE}/${directory}

GITHUB_PACKAGE_TOKEN=${token}
export GITHUB_PACKAGE_TOKEN

mkdir -p ${install_directory} && cd ${install_directory}
echo '@wpmedia:registry=https://npm.pkg.github.com' >> .npmrc
echo '//npm.pkg.github.com/:_authToken=${GITHUB_PACKAGE_TOKEN}' >> .npmrc
npm install ${package_name}
cp -R node_modules/* ${install_directory}

echo "install_directory" $(ls -l ${install_directory})