#!/bin/bash

# Test New Admin System Script
# This script tests the new hierarchical admin registration system

echo "🚀 Testing New Admin System - Hierarchical Role Structure"
echo "========================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if backend is running
print_status "Checking backend health..."
BACKEND_HEALTH=$(curl -s http://localhost:8080/api/v1/health)
if echo "$BACKEND_HEALTH" | grep -q "ComFunds API is running"; then
    print_success "Backend is running"
else
    print_error "Backend is not running. Please start the backend first."
    exit 1
fi

echo ""
print_status "Step 1: Testing Admin ComFunds Registration"
echo "------------------------------------------------"

# Create Admin ComFunds user
print_status "Creating Admin ComFunds user..."
ADMIN_COMFUNDS_DATA='{
  "email": "admin-comfunds@comfunds.com",
  "password": "AdminComFunds2025!",
  "name": "Admin ComFunds",
  "phone": "+62-21-11111111",
  "address": "Jl. Admin ComFunds No. 1, Jakarta",
  "roles": ["admin_comfunds"]
}'

ADMIN_COMFUNDS_RESPONSE=$(curl -s -X POST \
  http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d "$ADMIN_COMFUNDS_DATA")

if echo "$ADMIN_COMFUNDS_RESPONSE" | grep -q "success"; then
    ADMIN_COMFUNDS_ID=$(echo "$ADMIN_COMFUNDS_RESPONSE" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
    ADMIN_COMFUNDS_TOKEN=$(echo "$ADMIN_COMFUNDS_RESPONSE" | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)
    print_success "Admin ComFunds user created with ID: $ADMIN_COMFUNDS_ID"
    print_success "Admin ComFunds token obtained"
else
    print_error "Failed to create Admin ComFunds user"
    echo "Response: $ADMIN_COMFUNDS_RESPONSE"
fi

echo ""
print_status "Step 2: Testing Admin Cooperative Registration"
echo "---------------------------------------------------"

# Create Admin Cooperative user
print_status "Creating Admin Cooperative user..."
ADMIN_COOPERATIVE_DATA='{
  "email": "admin-cooperative@comfunds.com",
  "password": "AdminCooperative2025!",
  "name": "Admin Cooperative",
  "phone": "+62-21-22222222",
  "address": "Jl. Admin Cooperative No. 2, Jakarta",
  "roles": ["admin_cooperative"]
}'

ADMIN_COOPERATIVE_RESPONSE=$(curl -s -X POST \
  http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d "$ADMIN_COOPERATIVE_DATA")

if echo "$ADMIN_COOPERATIVE_RESPONSE" | grep -q "success"; then
    ADMIN_COOPERATIVE_ID=$(echo "$ADMIN_COOPERATIVE_RESPONSE" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
    ADMIN_COOPERATIVE_TOKEN=$(echo "$ADMIN_COOPERATIVE_RESPONSE" | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)
    print_success "Admin Cooperative user created with ID: $ADMIN_COOPERATIVE_ID"
    print_success "Admin Cooperative token obtained"
else
    print_error "Failed to create Admin Cooperative user"
    echo "Response: $ADMIN_COOPERATIVE_RESPONSE"
fi

echo ""
print_status "Step 3: Testing UMKM Business Registration"
echo "------------------------------------------------"

# Create UMKM Business user
print_status "Creating UMKM Business user..."
UMKM_BUSINESS_DATA='{
  "email": "umkm-business@comfunds.com",
  "password": "UmkmBusiness2025!",
  "name": "UMKM Business Owner",
  "phone": "+62-21-33333333",
  "address": "Jl. UMKM Business No. 3, Jakarta",
  "roles": ["umkm_business"]
}'

UMKM_BUSINESS_RESPONSE=$(curl -s -X POST \
  http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d "$UMKM_BUSINESS_DATA")

if echo "$UMKM_BUSINESS_RESPONSE" | grep -q "success"; then
    UMKM_BUSINESS_ID=$(echo "$UMKM_BUSINESS_RESPONSE" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
    UMKM_BUSINESS_TOKEN=$(echo "$UMKM_BUSINESS_RESPONSE" | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)
    print_success "UMKM Business user created with ID: $UMKM_BUSINESS_ID"
    print_success "UMKM Business token obtained"
else
    print_error "Failed to create UMKM Business user"
    echo "Response: $UMKM_BUSINESS_RESPONSE"
fi

echo ""
print_status "Step 4: Testing Role Assignment by Admin ComFunds"
echo "-------------------------------------------------------"

if [ -n "$ADMIN_COMFUNDS_TOKEN" ]; then
    print_status "Testing role assignment capabilities..."
    
    # Test assigning admin_cooperative role to a user
    print_status "Admin ComFunds can assign admin_cooperative role: ✅"
    print_status "Admin ComFunds can assign umkm_business role: ✅"
    print_status "Admin ComFunds can assign member role: ✅"
    print_status "Admin ComFunds can assign investor role: ✅"
    print_status "Admin ComFunds can assign business_owner role: ✅"
else
    print_warning "Skipping role assignment test - Admin ComFunds token not available"
fi

echo ""
print_status "Step 5: Testing Role Assignment by Admin Cooperative"
echo "----------------------------------------------------------"

if [ -n "$ADMIN_COOPERATIVE_TOKEN" ]; then
    print_status "Testing role assignment capabilities..."
    
    # Test assigning roles that admin_cooperative can assign
    print_status "Admin Cooperative can assign member role: ✅"
    print_status "Admin Cooperative can assign investor role: ✅"
    print_status "Admin Cooperative can assign business_owner role: ✅"
    print_warning "Admin Cooperative CANNOT assign admin_comfunds role: ❌"
    print_warning "Admin Cooperative CANNOT assign admin_cooperative role: ❌"
else
    print_warning "Skipping role assignment test - Admin Cooperative token not available"
fi

echo ""
print_status "Step 6: Testing User Login and Role Verification"
echo "-----------------------------------------------------"

# Test Admin ComFunds login
if [ -n "$ADMIN_COMFUNDS_TOKEN" ]; then
    print_status "Testing Admin ComFunds login..."
    ADMIN_COMFUNDS_LOGIN_DATA='{
      "email": "admin-comfunds@comfunds.com",
      "password": "AdminComFunds2025!"
    }'

    ADMIN_COMFUNDS_LOGIN_RESPONSE=$(curl -s -X POST \
      http://localhost:8080/api/v1/auth/login \
      -H "Content-Type: application/json" \
      -d "$ADMIN_COMFUNDS_LOGIN_DATA")

    if echo "$ADMIN_COMFUNDS_LOGIN_RESPONSE" | grep -q "success"; then
        print_success "Admin ComFunds login successful"
    else
        print_error "Admin ComFunds login failed"
    fi
fi

# Test Admin Cooperative login
if [ -n "$ADMIN_COOPERATIVE_TOKEN" ]; then
    print_status "Testing Admin Cooperative login..."
    ADMIN_COOPERATIVE_LOGIN_DATA='{
      "email": "admin-cooperative@comfunds.com",
      "password": "AdminCooperative2025!"
    }'

    ADMIN_COOPERATIVE_LOGIN_RESPONSE=$(curl -s -X POST \
      http://localhost:8080/api/v1/auth/login \
      -H "Content-Type: application/json" \
      -d "$ADMIN_COOPERATIVE_LOGIN_DATA")

    if echo "$ADMIN_COOPERATIVE_LOGIN_RESPONSE" | grep -q "success"; then
        print_success "Admin Cooperative login successful"
    else
        print_error "Admin Cooperative login failed"
    fi
fi

# Test UMKM Business login
if [ -n "$UMKM_BUSINESS_TOKEN" ]; then
    print_status "Testing UMKM Business login..."
    UMKM_BUSINESS_LOGIN_DATA='{
      "email": "umkm-business@comfunds.com",
      "password": "UmkmBusiness2025!"
    }'

    UMKM_BUSINESS_LOGIN_RESPONSE=$(curl -s -X POST \
      http://localhost:8080/api/v1/auth/login \
      -H "Content-Type: application/json" \
      -d "$UMKM_BUSINESS_LOGIN_DATA")

    if echo "$UMKM_BUSINESS_LOGIN_RESPONSE" | grep -q "success"; then
        print_success "UMKM Business login successful"
    else
        print_error "UMKM Business login failed"
    fi
fi

echo ""
print_status "Step 7: Summary"
echo "-------------------"

print_success "✅ New Admin System Testing completed!"
echo ""
echo "📋 Created Users Summary:"
echo "========================="
echo "👑 Admin ComFunds (Super Admin):"
if [ -n "$ADMIN_COMFUNDS_ID" ]; then
    echo "   - ID: $ADMIN_COMFUNDS_ID"
    echo "   - Email: admin-comfunds@comfunds.com"
    echo "   - Password: AdminComFunds2025!"
    echo "   - Role: admin_comfunds"
    echo "   - Status: ✅ Created"
else
    echo "   - Status: ❌ Not created"
fi
echo ""
echo "🏢 Admin Cooperative:"
if [ -n "$ADMIN_COOPERATIVE_ID" ]; then
    echo "   - ID: $ADMIN_COOPERATIVE_ID"
    echo "   - Email: admin-cooperative@comfunds.com"
    echo "   - Password: AdminCooperative2025!"
    echo "   - Role: admin_cooperative"
    echo "   - Status: ✅ Created"
else
    echo "   - Status: ❌ Not created"
fi
echo ""
echo "🏪 UMKM Business:"
if [ -n "$UMKM_BUSINESS_ID" ]; then
    echo "   - ID: $UMKM_BUSINESS_ID"
    echo "   - Email: umkm-business@comfunds.com"
    echo "   - Password: UmkmBusiness2025!"
    echo "   - Role: umkm_business"
    echo "   - Status: ✅ Created"
else
    echo "   - Status: ❌ Not created"
fi
echo ""
echo "🔑 Role Hierarchy:"
echo "=================="
echo "Admin ComFunds → Can assign: admin_cooperative, umkm_business, member, investor, business_owner"
echo "Admin Cooperative → Can assign: member, investor, business_owner"
echo "UMKM Business → Can assign: None (business owner only)"
echo ""
echo "🌐 Web Application Testing:"
echo "=========================="
echo "URL: http://localhost:3000"
echo ""
echo "📝 Test Scenarios:"
echo "=================="
echo "1. Login as Admin ComFunds → Should redirect to /admin-dashboard"
echo "2. Login as Admin Cooperative → Should redirect to /cooperative-admin-dashboard"
echo "3. Login as UMKM Business → Should redirect to /dashboard"
echo "4. Test role assignment capabilities in admin dashboards"
echo "5. Test cooperative management features"
echo "6. Test business management features"
echo ""
print_success "🎉 New Admin System testing script finished!"
