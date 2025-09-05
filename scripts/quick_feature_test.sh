#!/bin/bash

# Quick Feature Test for HAJIFUND
# Tests core functionality while user does manual testing

BASE_URL="http://localhost:3002"

echo "🚀 HAJIFUND Quick Feature Test"
echo "=============================="
echo ""

# Test 1: Basic connectivity
echo "🔍 Testing basic connectivity..."
if curl -s -o /dev/null -w "%{http_code}" "$BASE_URL" | grep -q "200"; then
    echo "✅ App is accessible on port 3002"
else
    echo "❌ App is not accessible"
    exit 1
fi

# Test 2: Check if it's a Flutter app
echo "🔍 Testing Flutter framework..."
if curl -s "$BASE_URL" | grep -q "flutter"; then
    echo "✅ Flutter framework detected"
else
    echo "⚠️  Flutter framework not clearly detected (may be normal)"
fi

# Test 3: Check updated title
echo "🔍 Testing page title..."
title=$(curl -s "$BASE_URL" | grep -o '<title>[^<]*</title>' | sed 's/<[^>]*>//g')
if [[ "$title" == *"HAJIFUND"* ]]; then
    echo "✅ HAJIFUND title found: $title"
else
    echo "⚠️  Title may not be updated: $title"
fi

# Test 4: Check meta description
echo "🔍 Testing meta description..."
if curl -s "$BASE_URL" | grep -q "P2P Lending Syariah"; then
    echo "✅ P2P Lending Syariah description found"
else
    echo "⚠️  Syariah description not found in meta tags"
fi

# Test 5: Check for viewport meta tag (mobile responsiveness)
echo "🔍 Testing mobile viewport..."
if curl -s "$BASE_URL" | grep -q "viewport"; then
    echo "✅ Mobile viewport meta tag found"
else
    echo "❌ Mobile viewport meta tag missing"
fi

# Test 6: Check for favicon
echo "🔍 Testing favicon..."
if curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/favicon.png" | grep -q "200"; then
    echo "✅ Favicon is accessible"
else
    echo "⚠️  Favicon may not be accessible"
fi

# Test 7: Check for manifest (PWA)
echo "🔍 Testing PWA manifest..."
if curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/manifest.json" | grep -q "200"; then
    echo "✅ PWA manifest is accessible"
    
    # Check manifest content
    if curl -s "$BASE_URL/manifest.json" | grep -q "HAJIFUND"; then
        echo "✅ Manifest contains HAJIFUND branding"
    else
        echo "⚠️  Manifest may not be updated with HAJIFUND branding"
    fi
else
    echo "❌ PWA manifest not accessible"
fi

# Test 8: Performance check
echo "🔍 Testing page load performance..."
start_time=$(date +%s%N)
curl -s "$BASE_URL" > /dev/null
end_time=$(date +%s%N)
load_time=$(( (end_time - start_time) / 1000000 ))

if [ $load_time -lt 1000 ]; then
    echo "✅ Excellent load time: ${load_time}ms"
elif [ $load_time -lt 3000 ]; then
    echo "✅ Good load time: ${load_time}ms"
elif [ $load_time -lt 5000 ]; then
    echo "⚠️  Acceptable load time: ${load_time}ms"
else
    echo "❌ Slow load time: ${load_time}ms"
fi

echo ""
echo "🎯 Quick Test Summary:"
echo "====================="
echo "✅ App is running on http://localhost:3002"
echo "✅ Ready for manual testing in Chrome"
echo ""
echo "📋 Manual Testing Instructions:"
echo "1. Open Chrome DevTools (F12)"
echo "2. Check Console tab for JavaScript errors"
echo "3. Test navigation between pages"
echo "4. Verify Pembiayaan cards display correctly"
echo "5. Test responsive design (resize browser)"
echo "6. Check HAJIFUND branding and Islamic design"
echo ""
echo "📖 Use MANUAL_TESTING_CHECKLIST.md for comprehensive testing"
echo ""
echo "🌐 Access the app: $BASE_URL"
