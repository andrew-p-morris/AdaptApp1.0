PROJECT=Adapt/Adapt.xcodeproj
SCHEME=Adapt
SIM_DEVICE="iPhone 15"

.PHONY: run-server migrate serve build-server test-server
build-server:
	swift build -v

test-server:
	swift test -v

migrate:
	swift run Run migrate

serve:
	swift run Run serve

run-server: build-server migrate serve

.PHONY: boot-sim build-ios app-path bundle-id install-ios launch-ios run-ios
boot-sim:
	@xcrun simctl boot $(SIM_DEVICE) || true
	@open -a Simulator || true

build-ios:
	xcodebuild -project $(PROJECT) -scheme $(SCHEME) -configuration Debug -destination 'platform=iOS Simulator,name=$(SIM_DEVICE)' build

app-path:
	@APP_PATH=$$(xcodebuild -project $(PROJECT) -scheme $(SCHEME) -showBuildSettings -destination 'platform=iOS Simulator,name=$(SIM_DEVICE)' 2>/dev/null | awk -F'= ' '/TARGET_BUILD_DIR/ {dir=$$2} /WRAPPER_NAME/ {name=$$2} END {print dir "/" name}'); \
	echo $$APP_PATH

bundle-id:
	@xcodebuild -project $(PROJECT) -scheme $(SCHEME) -showBuildSettings -destination 'platform=iOS Simulator,name=$(SIM_DEVICE)' 2>/dev/null | awk -F'= ' '/PRODUCT_BUNDLE_IDENTIFIER/ {print $$2}' | tail -n1

install-ios:
	@APP_PATH=$$(xcodebuild -project $(PROJECT) -scheme $(SCHEME) -showBuildSettings -destination 'platform=iOS Simulator,name=$(SIM_DEVICE)' 2>/dev/null | awk -F'= ' '/TARGET_BUILD_DIR/ {dir=$$2} /WRAPPER_NAME/ {name=$$2} END {print dir "/" name}'); \
	xcrun simctl install booted "$$APP_PATH"

launch-ios:
	@BUNDLE_ID=$$(xcodebuild -project $(PROJECT) -scheme $(SCHEME) -showBuildSettings -destination 'platform=iOS Simulator,name=$(SIM_DEVICE)' 2>/dev/null | awk -F'= ' '/PRODUCT_BUNDLE_IDENTIFIER/ {print $$2}' | tail -n1); \
	xcrun simctl launch booted "$$BUNDLE_ID" || true

run-ios: boot-sim build-ios install-ios launch-ios


