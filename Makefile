# Simple Flutter helper targets

.PHONY: format-package format-demo format-all lint-package lint-demo lint-all \
	test-package-unit test-package-unit-coverage \
	test-package-widget test-package-widget-coverage \
	test-package-all \
	test-demo-integration test-demo-integration-coverage \
	test-package-integration test-package-integration-coverage

# Formatting
format-package:
	dart format --set-exit-if-changed .

format-demo:
	cd demo && dart format --set-exit-if-changed . && cd -

format-all: format-package format-demo


# Linting
lint-package:
	flutter analyze

lint-demo:
	cd demo && flutter analyze && cd -

lint-all: lint-package lint-demo

# Testing: Unit & Widget tests

test-package-unit:
	flutter test test/unit

test-package-unit-coverage:
	mkdir -p coverage/unit build/test-results/unit
	@if [ "$$CI" = "true" ] && command -v tojunit >/dev/null; then \
	  bash -o pipefail -c "flutter test --coverage --coverage-path=coverage/unit/lcov.info --machine test/unit \
	    | tee build/test-results/unit/flutter.json \
	    | tojunit --output build/test-results/unit/junit.xml"; \
	else \
	  flutter test --coverage --coverage-path=coverage/unit/lcov.info test/unit; \
	fi

test-package-widget:
	flutter test test/widget

test-package-widget-coverage:
	mkdir -p coverage/widget build/test-results/widget
	@if [ "$$CI" = "true" ] && command -v tojunit >/dev/null; then \
	  bash -o pipefail -c "flutter test --coverage --coverage-path=coverage/widget/lcov.info --machine test/widget \
	    | tee build/test-results/widget/flutter.json \
	    | tojunit --output build/test-results/widget/junit.xml"; \
	else \
	  flutter test --coverage --coverage-path=coverage/widget/lcov.info test/widget; \
	fi

test-package-all:
	$(MAKE) test-package-unit
	$(MAKE) test-package-widget

# Testing: Integration tests

# Runs the demo application's dedicated integration smoke test
test-demo-integration:
	cd demo && flutter test integration_test/tests/demo_test.dart && cd -

test-demo-integration-coverage:
	cd demo && \
	  mkdir -p coverage/integration build/test-results/integration && \
	  if [ "$$CI" = "true" ] && command -v tojunit >/dev/null; then \
	    bash -o pipefail -c "flutter test --coverage --coverage-path=coverage/integration/lcov.info --machine integration_test/tests/demo_test.dart --dart-define=CI=true \
	      | tee build/test-results/integration/flutter.json \
	      | tojunit --output build/test-results/integration/junit.xml"; \
	  else \
	    flutter test --coverage --coverage-path=coverage/integration/lcov.info integration_test/tests/demo_test.dart --dart-define=CI=true; \
	  fi && cd -

# Runs the package widget suite with integration binding for visual debugging if desired
test-package-integration:
	cd demo && flutter test integration_test/tests/widget_suite_test.dart && cd -

test-package-integration-coverage:
	cd demo && \
	  mkdir -p coverage/package_integration build/test-results/package_integration && \
	  if [ "$$CI" = "true" ] && command -v tojunit >/dev/null; then \
	    bash -o pipefail -c "flutter test --coverage --coverage-path=coverage/package_integration/lcov.info --machine integration_test/tests/widget_suite_test.dart \
	      | tee build/test-results/package_integration/flutter.json \
	      | tojunit --output build/test-results/package_integration/junit.xml"; \
	  else \
	    flutter test --coverage --coverage-path=coverage/package_integration/lcov.info integration_test/tests/widget_suite_test.dart; \
	  fi && cd -

test-integration-coverage:
	cd demo && \
	  mkdir -p coverage/integration build/test-results/integration && \
	  if [ "$$CI" = "true" ] && command -v tojunit >/dev/null; then \
	    bash -o pipefail -c "flutter test --coverage --coverage-path=coverage/integration/lcov.info --machine integration_test/tests --dart-define=CI=true \
	      | tee build/test-results/integration/flutter.json \
	      | tojunit --output build/test-results/integration/junit.xml"; \
	  else \
	    flutter test --coverage --coverage-path=coverage/integration/lcov.info integration_test/tests --dart-define=CI=true; \
	  fi && cd -
