#!/bin/bash

# HAJIFUND Web Application Feature Testing Script
# Tests all major features of the web app running on port 3002

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Print functions
print_status() {
    echo -e "${BLUE}🔍 Testing: $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ PASS: $1${NC}"
}

print_error() {
    echo -e "${RED}❌ FAIL: $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  WARNING: $1${NC}"
}

print_info() {
    echo -e "${PURPLE}ℹ️  INFO: $1${NC}"
}

# Test configuration
BASE_URL="http://localhost:3002"
TEST_RESULTS=()

# Function to test HTTP endpoint
test_endpoint() {
    local endpoint=$1
    local expected_status=${2:-200}
    local description=$3
    
    print_status "$description"
    
    local response_code=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL$endpoint")
    
    if [ "$response_code" -eq "$expected_status" ]; then
        print_success "$description - Status: $response_code"
        TEST_RESULTS+=("PASS: $description")
        return 0
    else
        print_error "$description - Expected: $expected_status, Got: $response_code"
        TEST_RESULTS+=("FAIL: $description")
        return 1
    fi
}

# Function to test page content
test_page_content() {
    local endpoint=$1
    local search_text=$2
    local description=$3
    
    print_status "$description"
    
    local content=$(curl -s "$BASE_URL$endpoint")
    
    if echo "$content" | grep -q "$search_text"; then
        print_success "$description - Content found"
        TEST_RESULTS+=("PASS: $description")
        return 0
    else
        print_error "$description - Content not found: '$search_text'"
        TEST_RESULTS+=("FAIL: $description")
        return 1
    fi
}

# Function to test JavaScript functionality (basic)
test_js_functionality() {
    local endpoint=$1
    local description=$2
    
    print_status "$description"
    
    local content=$(curl -s "$BASE_URL$endpoint")
    
    if echo "$content" | grep -q "flutter"; then
        print_success "$description - Flutter app detected"
        TEST_RESULTS+=("PASS: $description")
        return 0
    else
        print_error "$description - Flutter app not detected"
        TEST_RESULTS+=("FAIL: $description")
        return 1
    fi
}

echo ""
echo "🚀 HAJIFUND Web Application Testing"
echo "===================================="
echo "Testing URL: $BASE_URL"
echo "Browser: Chrome"
echo "Date: $(date)"
echo ""

# Test 1: Basic Connectivity
print_info "=== BASIC CONNECTIVITY TESTS ==="
test_endpoint "" 200 "Main application loads"
test_endpoint "/favicon.ico" 200 "Favicon loads"

echo ""

# Test 2: Core Pages Accessibility
print_info "=== CORE PAGES ACCESSIBILITY ==="
test_endpoint "" 200 "Landing/Home page"
test_endpoint "/login" 200 "Login page"
test_endpoint "/register" 200 "Registration page"
test_endpoint "/dashboard" 200 "Dashboard page"

echo ""

# Test 3: HAJIFUND Branding and Content
print_info "=== HAJIFUND BRANDING TESTS ==="
test_page_content "" "HAJIFUND" "HAJIFUND branding on homepage"
test_page_content "" "P2P Lending Syariah" "P2P Lending Syariah tagline"
test_page_content "" "Syariah" "Islamic/Syariah content"
test_page_content "" "Halal" "Halal content"

echo ""

# Test 4: Navigation and UI Components
print_info "=== NAVIGATION & UI TESTS ==="
test_page_content "" "Beranda" "Beranda navigation"
test_page_content "" "Investasi" "Investasi navigation"
test_page_content "" "Pembiayaan" "Pembiayaan navigation"
test_page_content "" "Tentang" "Tentang navigation"
test_page_content "" "Kontak" "Kontak navigation"

echo ""

# Test 5: Flutter Web Application
print_info "=== FLUTTER WEB APP TESTS ==="
test_js_functionality "" "Flutter web application"
test_page_content "" "flutter" "Flutter framework detection"
test_page_content "" "main.dart.js" "Flutter compiled JavaScript"

echo ""

# Test 6: Design System Elements
print_info "=== DESIGN SYSTEM TESTS ==="
test_page_content "" "Inter" "Inter font family"
test_page_content "" "Poppins" "Poppins font family"
test_page_content "" "#00A86B" "Primary green color"

echo ""

# Test 7: Security Headers and Configuration
print_info "=== SECURITY & CONFIGURATION TESTS ==="
print_status "Checking security headers"
curl -s -I "$BASE_URL" | grep -i "x-frame-options\|content-security-policy\|x-content-type-options" || print_warning "Some security headers missing"

echo ""

# Test 8: Performance and Loading
print_info "=== PERFORMANCE TESTS ==="
print_status "Measuring page load time"
start_time=$(date +%s%N)
curl -s "$BASE_URL" > /dev/null
end_time=$(date +%s%N)
load_time=$(( (end_time - start_time) / 1000000 ))
if [ $load_time -lt 2000 ]; then
    print_success "Page load time: ${load_time}ms (Good)"
    TEST_RESULTS+=("PASS: Page load performance")
elif [ $load_time -lt 5000 ]; then
    print_warning "Page load time: ${load_time}ms (Acceptable)"
    TEST_RESULTS+=("WARN: Page load performance")
else
    print_error "Page load time: ${load_time}ms (Slow)"
    TEST_RESULTS+=("FAIL: Page load performance")
fi

echo ""

# Test 9: Mobile Responsiveness (basic check)
print_info "=== MOBILE RESPONSIVENESS TESTS ==="
print_status "Testing mobile viewport meta tag"
if curl -s "$BASE_URL" | grep -q "viewport"; then
    print_success "Mobile viewport meta tag found"
    TEST_RESULTS+=("PASS: Mobile viewport")
else
    print_error "Mobile viewport meta tag missing"
    TEST_RESULTS+=("FAIL: Mobile viewport")
fi

echo ""

# Test 10: Asset Loading
print_info "=== ASSET LOADING TESTS ==="
test_endpoint "/assets/fonts/MaterialIcons-Regular.otf" 200 "Material Icons font"
test_endpoint "/assets/AssetManifest.json" 200 "Asset manifest"

echo ""

# Test 11: Browser Console Errors (simulated)
print_info "=== JAVASCRIPT ERROR TESTS ==="
print_status "Checking for common JavaScript issues"
content=$(curl -s "$BASE_URL")
if echo "$content" | grep -q "onerror\|throw\|Error"; then
    print_warning "Potential JavaScript errors detected in source"
    TEST_RESULTS+=("WARN: JavaScript errors")
else
    print_success "No obvious JavaScript errors in source"
    TEST_RESULTS+=("PASS: JavaScript errors")
fi

echo ""

# Test Summary
print_info "=== TEST SUMMARY ==="
echo ""
echo "📊 Test Results:"
echo "================"

pass_count=0
fail_count=0
warn_count=0

for result in "${TEST_RESULTS[@]}"; do
    if [[ $result == PASS:* ]]; then
        echo -e "${GREEN}✅ $result${NC}"
        ((pass_count++))
    elif [[ $result == FAIL:* ]]; then
        echo -e "${RED}❌ $result${NC}"
        ((fail_count++))
    elif [[ $result == WARN:* ]]; then
        echo -e "${YELLOW}⚠️  $result${NC}"
        ((warn_count++))
    fi
done

echo ""
echo "📈 Statistics:"
echo "============="
echo -e "${GREEN}✅ Passed: $pass_count${NC}"
echo -e "${RED}❌ Failed: $fail_count${NC}"
echo -e "${YELLOW}⚠️  Warnings: $warn_count${NC}"
echo "📊 Total Tests: $((pass_count + fail_count + warn_count))"

# Calculate success rate
if [ $((pass_count + fail_count + warn_count)) -gt 0 ]; then
    success_rate=$(( (pass_count * 100) / (pass_count + fail_count + warn_count) ))
    echo "🎯 Success Rate: ${success_rate}%"
fi

echo ""

# Overall result
if [ $fail_count -eq 0 ]; then
    if [ $warn_count -eq 0 ]; then
        print_success "🎉 ALL TESTS PASSED! HAJIFUND web app is working perfectly!"
    else
        print_warning "⚠️  Tests completed with warnings. App is functional but has minor issues."
    fi
else
    print_error "❌ Some tests failed. Please review and fix the issues."
fi

echo ""
print_info "💡 Manual Testing Recommendations:"
echo "  1. Open Chrome DevTools (F12) to check for console errors"
echo "  2. Test responsive design by resizing browser window"
echo "  3. Test navigation by clicking menu items"
echo "  4. Test forms by trying to register/login"
echo "  5. Test Islamic design elements and typography"
echo "  6. Test financing cards layout (should not overlap)"
echo ""

print_info "🌐 Access the app: $BASE_URL"
echo "📱 Test on mobile: Use Chrome DevTools device simulation"
echo "🔍 For detailed testing: Use browser developer tools"

echo ""
print_success "🏁 Automated testing completed!"
echo "⏰ Test duration: $(date)"
