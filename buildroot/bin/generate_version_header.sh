#!/usr/bin/env bash
# generate_version_header_for_marlin

DIR="${1}"

BUILDATE=$(date '+%s')
DISTDATE=$(date '+%Y-%m-%d %H:%M')

BRANCH=$(git -C "${DIR}" symbolic-ref -q --short HEAD)
VERSION=$(git -C "${DIR}" describe --tags --first-parent 2>/dev/null)

if [ -z "${BRANCH}" ]; then
  BRANCH=$(echo "${TRAVIS_BRANCH}")
fi

if [ -z "${VERSION}" ]; then
  VERSION=$(git -C "${DIR}" describe --tags --first-parent --always 2>/dev/null)
fi

SHORT_BUILD_VERSION=$(echo "${BRANCH}")
DETAILED_BUILD_VERSION=$(echo "${BRANCH}-${VERSION}")

# Gets some misc options from their defaults
DEFAULT_MACHINE_UUID=$(awk -F'"' \
  '/#define DEFAULT_MACHINE_UUID/{ print $2 }' < "${DIR}/Version.h")
MACHINE_NAME=$(awk -F'"' \
  '/#define MACHINE_NAME/{ print $2 }' < "${DIR}/Version.h")
PROTOCOL_VERSION=$(awk -F'"' \
  '/#define PROTOCOL_VERSION/{ print $2 }' < "${DIR}/Version.h")
SOURCE_CODE_URL=$(awk -F'"' \
  '/#define SOURCE_CODE_URL/{ print $2 }' < "${DIR}/Version.h")
WEBSITE_URL=$(awk -F'"' \
  '/#define WEBSITE_URL/{ print $2 }' < "${DIR}/Version.h")

cat > "${DIR}/_Version.h" <<EOF
/**
 * THIS FILE IS AUTOMATICALLY GENERATED DO NOT MANUALLY EDIT IT.
 * IT DOES NOT GET COMMITTED TO THE REPOSITORY.
 *
 * Branch: ${BRANCH}
 * Version: ${VERSION}
 */

#define BUILD_UNIX_DATETIME "${BUILDATE}"
#define STRING_DISTRIBUTION_DATE "${DISTDATE}"

#define SHORT_BUILD_VERSION "${SHORT_BUILD_VERSION}"
#define DETAILED_BUILD_VERSION "${DETAILED_BUILD_VERSION}"

#define PROTOCOL_VERSION "${PROTOCOL_VERSION}"
#define MACHINE_NAME "${MACHINE_NAME}"
#define SOURCE_CODE_URL "${SOURCE_CODE_URL}"
#define DEFAULT_MACHINE_UUID "${DEFAULT_MACHINE_UUID}"
#define WEBSITE_URL "${WEBSITE_URL}"
EOF