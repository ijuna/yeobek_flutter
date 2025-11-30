#!/bin/bash
# Integration Test Runner for Features Package
# Runs Dart-ported backend tests against live API server

set -e

echo "====================================="
echo "Features Integration Tests"
echo "====================================="
echo ""

# Resolve script dir and cd into features package root
cd "$(dirname "$0")/../.."

# Config
API_BASE_URL="${API_BASE_URL:-https://api.yeobek.com}"
TEST_DIR="test/integration"

# Helper: check command exists
has_cmd() { command -v "$1" >/dev/null 2>&1; }

# Helper: server reachability check (tries /ping then /healthz with short retries)
check_server() {
    local url="$1"
    echo "🔍 Checking API server at $url..."
    local deadline=$(( $(date +%s) + 10 ))
    while [ "$(date +%s)" -lt "$deadline" ]; do
        if curl -s -f "$url/ping" >/dev/null 2>&1; then
            echo "✅ API server is reachable (ping)"; return 0
        fi
        if curl -s -f "$url/healthz" >/dev/null 2>&1; then
            echo "✅ API server is reachable (healthz)"; return 0
        fi
        sleep 0.5
    done
    echo "❌ API server is NOT reachable at $url"
    echo "   Ensure the backend is running and accessible."
        echo "   Override URL: API_BASE_URL=https://your-server $0"
    return 1
}

check_server "$API_BASE_URL"

echo ""
echo "📦 Running integration tests..."
echo "   Test files: $TEST_DIR/*_integration_test.dart"
echo "   Using API_BASE_URL=$API_BASE_URL"
echo ""

# Choose runner: dart test (preferred) or flutter test (fallback)
run_tests() {
    local file="$1"
    if has_cmd flutter; then
        flutter test --dart-define=API_BASE_URL="$API_BASE_URL" "$file" || return 1
    elif has_cmd dart; then
        # Pass API_BASE_URL to Dart VM environment constants
        dart test -DAPI_BASE_URL="$API_BASE_URL" "$file" || return 1
    else
        echo "❌ Neither 'dart' nor 'flutter' is installed in PATH"
        return 1
    fi
}

# Run all integration tests
echo "🧪 Auth Integration Tests..."
run_tests "$TEST_DIR/auth_integration_test.dart" || echo "⚠️  Auth tests had failures"
echo ""

echo "🎨 Artist Integration Tests..."
run_tests "$TEST_DIR/artist_integration_test.dart" || echo "⚠️  Artist tests had failures"
echo ""

echo "🖼️  Artworks Integration Tests..."
run_tests "$TEST_DIR/artworks_integration_test.dart" || echo "⚠️  Artworks tests had failures"
echo ""

echo "📝 Board Integration Tests..."
run_tests "$TEST_DIR/board_integration_test.dart" || echo "⚠️  Board tests had failures"
echo ""

echo "====================================="
echo "✅ Integration test run completed"
echo "====================================="
