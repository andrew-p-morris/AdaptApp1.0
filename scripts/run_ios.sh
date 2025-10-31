#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

PROJECT=Adapt/Adapt.xcodeproj
SCHEME=Adapt
DEVICE_NAME="iPhone 15"

echo "> Booting simulator: ${DEVICE_NAME}"
xcrun simctl boot "${DEVICE_NAME}" || true
open -a Simulator || true

echo "> Building iOS app for ${DEVICE_NAME}"
xcodebuild -project "$PROJECT" -scheme "$SCHEME" -configuration Debug -destination "platform=iOS Simulator,name=${DEVICE_NAME}" build

echo "> Determining build output path"
APP_PATH=$(xcodebuild -project "$PROJECT" -scheme "$SCHEME" -showBuildSettings -destination "platform=iOS Simulator,name=${DEVICE_NAME}" 2>/dev/null | awk -F'= ' '/TARGET_BUILD_DIR/ {dir=$2} /WRAPPER_NAME/ {name=$2} END {print dir "/" name}')
echo "APP_PATH=$APP_PATH"

echo "> Installing app to booted simulator"
xcrun simctl install booted "$APP_PATH"

echo "> Determining bundle identifier"
BUNDLE_ID=$(xcodebuild -project "$PROJECT" -scheme "$SCHEME" -showBuildSettings -destination "platform=iOS Simulator,name=${DEVICE_NAME}" 2>/dev/null | awk -F'= ' '/PRODUCT_BUNDLE_IDENTIFIER/ {print $2}' | tail -n1)
echo "BUNDLE_ID=$BUNDLE_ID"

echo "> Launching app"
xcrun simctl launch booted "$BUNDLE_ID" || true

echo "> Done."


