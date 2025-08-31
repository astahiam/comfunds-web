#!/bin/bash

# Complete Workflow Testing Script for ComFunds v2
# This script creates cooperatives, users, businesses, and projects for testing

echo "🚀 Starting Complete Workflow Testing for ComFunds v2"
echo "===================================================="

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
print_status "Step 1: Login as Admin to get token"
echo "------------------------------------------"

# Login as admin to get token
print_status "Logging in as admin-ryan..."
ADMIN_LOGIN_DATA='{
  "email": "admin-ryan@comfunds.com",
  "password": "AdminRyan2025!"
}'

ADMIN_LOGIN_RESPONSE=$(curl -s -X POST \
  http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d "$ADMIN_LOGIN_DATA")

if echo "$ADMIN_LOGIN_RESPONSE" | grep -q "success"; then
    ADMIN_TOKEN=$(echo "$ADMIN_LOGIN_RESPONSE" | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)
    print_success "Admin login successful"
    print_status "Admin token obtained"
else
    print_error "Admin login failed"
    echo "Response: $ADMIN_LOGIN_RESPONSE"
    exit 1
fi

echo ""
print_status "Step 2: Creating Cooperatives (as Admin)"
echo "-----------------------------------------------"

# Create Hajifund Cooperative
print_status "Creating Hajifund Cooperative..."
HAJIFUND_DATA='{
  "name": "Hajifund",
  "description": "Hajifund Cooperative for Hajj funding and investments",
  "address": "Jl. Hajifund No. 1, Jakarta",
  "phone": "+62-21-12345678",
  "email": "info@hajifund.coop",
  "website": "https://hajifund.coop",
  "registration_number": "COOP-001-2025",
  "tax_id": "TAX-001-2025",
  "bank_account": "1234567890",
  "bank_name": "Bank Hajifund",
  "status": "active"
}'

HAJIFUND_RESPONSE=$(curl -s -X POST \
  http://localhost:8080/api/v1/cooperatives \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -d "$HAJIFUND_DATA")

if echo "$HAJIFUND_RESPONSE" | grep -q "success"; then
    HAJIFUND_ID=$(echo "$HAJIFUND_RESPONSE" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
    print_success "Hajifund Cooperative created with ID: $HAJIFUND_ID"
else
    print_error "Failed to create Hajifund Cooperative"
    echo "Response: $HAJIFUND_RESPONSE"
    # Try to get existing cooperative
    print_status "Trying to get existing Hajifund cooperative..."
    COOPERATIVES_RESPONSE=$(curl -s -H "Authorization: Bearer $ADMIN_TOKEN" http://localhost:8080/api/v1/cooperatives)
    if echo "$COOPERATIVES_RESPONSE" | grep -q "Hajifund"; then
        HAJIFUND_ID=$(echo "$COOPERATIVES_RESPONSE" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
        print_success "Found existing Hajifund Cooperative with ID: $HAJIFUND_ID"
    else
        print_error "Could not find Hajifund cooperative"
        HAJIFUND_ID=""
    fi
fi

# Create Sidana Cooperative
print_status "Creating Sidana Cooperative..."
SIDANA_DATA='{
  "name": "Sidana",
  "description": "Sidana Cooperative for community development and investments",
  "address": "Jl. Sidana No. 2, Bandung",
  "phone": "+62-22-87654321",
  "email": "info@sidana.coop",
  "website": "https://sidana.coop",
  "registration_number": "COOP-002-2025",
  "tax_id": "TAX-002-2025",
  "bank_account": "0987654321",
  "bank_name": "Bank Sidana",
  "status": "active"
}'

SIDANA_RESPONSE=$(curl -s -X POST \
  http://localhost:8080/api/v1/cooperatives \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -d "$SIDANA_DATA")

if echo "$SIDANA_RESPONSE" | grep -q "success"; then
    SIDANA_ID=$(echo "$SIDANA_RESPONSE" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
    print_success "Sidana Cooperative created with ID: $SIDANA_ID"
else
    print_error "Failed to create Sidana Cooperative"
    echo "Response: $SIDANA_RESPONSE"
    # Try to get existing cooperative
    print_status "Trying to get existing Sidana cooperative..."
    if [ -n "$COOPERATIVES_RESPONSE" ]; then
        if echo "$COOPERATIVES_RESPONSE" | grep -q "Sidana"; then
            SIDANA_ID=$(echo "$COOPERATIVES_RESPONSE" | grep -o '"id":"[^"]*"' | tail -1 | cut -d'"' -f4)
            print_success "Found existing Sidana Cooperative with ID: $SIDANA_ID"
        else
            print_error "Could not find Sidana cooperative"
            SIDANA_ID=""
        fi
    else
        SIDANA_ID=""
    fi
fi

echo ""
print_status "Step 3: Creating Users"
echo "----------------------------"

# Create Kharisma user (member of Hajifund)
print_status "Creating Kharisma user (member of Hajifund)..."
if [ -n "$HAJIFUND_ID" ]; then
    KHARISMA_DATA='{
      "email": "kharisma@hajifund.coop",
      "password": "Kharisma2025!",
      "name": "Kharisma",
      "phone": "+62-812-34567890",
      "address": "Jl. Kharisma No. 10, Jakarta",
      "cooperative_id": "'$HAJIFUND_ID'",
      "roles": ["member", "business_owner"]
    }'
else
    KHARISMA_DATA='{
      "email": "kharisma@hajifund.coop",
      "password": "Kharisma2025!",
      "name": "Kharisma",
      "phone": "+62-812-34567890",
      "address": "Jl. Kharisma No. 10, Jakarta",
      "roles": ["member", "business_owner"]
    }'
fi

KHARISMA_RESPONSE=$(curl -s -X POST \
  http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d "$KHARISMA_DATA")

if echo "$KHARISMA_RESPONSE" | grep -q "success"; then
    KHARISMA_USER_ID=$(echo "$KHARISMA_RESPONSE" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
    KHARISMA_TOKEN=$(echo "$KHARISMA_RESPONSE" | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)
    print_success "Kharisma user created with ID: $KHARISMA_USER_ID"
    if [ -n "$HAJIFUND_ID" ]; then
        print_success "Kharisma is a member of Hajifund Cooperative"
    else
        print_warning "Kharisma created without cooperative (cooperative not found)"
    fi
else
    print_error "Failed to create Kharisma user"
    echo "Response: $KHARISMA_RESPONSE"
fi

# Create additional test users
print_status "Creating additional test users..."

# Test user 1 (member of Sidana)
if [ -n "$SIDANA_ID" ]; then
    TEST_USER1_DATA='{
      "email": "testuser1@sidana.coop",
      "password": "TestUser2025!",
      "name": "Test User 1",
      "phone": "+62-811-11111111",
      "address": "Jl. Test No. 1, Bandung",
      "cooperative_id": "'$SIDANA_ID'",
      "roles": ["member"]
    }'
else
    TEST_USER1_DATA='{
      "email": "testuser1@sidana.coop",
      "password": "TestUser2025!",
      "name": "Test User 1",
      "phone": "+62-811-11111111",
      "address": "Jl. Test No. 1, Bandung",
      "roles": ["member"]
    }'
fi

TEST_USER1_RESPONSE=$(curl -s -X POST \
  http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d "$TEST_USER1_DATA")

if echo "$TEST_USER1_RESPONSE" | grep -q "success"; then
    print_success "Test User 1 created"
    if [ -n "$SIDANA_ID" ]; then
        print_success "Test User 1 is a member of Sidana Cooperative"
    else
        print_warning "Test User 1 created without cooperative"
    fi
else
    print_error "Failed to create Test User 1"
    echo "Response: $TEST_USER1_RESPONSE"
fi

# Test user 2 (investor)
TEST_USER2_DATA='{
  "email": "investor@comfunds.com",
  "password": "Investor2025!",
  "name": "Test Investor",
  "phone": "+62-822-22222222",
  "address": "Jl. Investor No. 2, Jakarta",
  "roles": ["investor"]
}'

TEST_USER2_RESPONSE=$(curl -s -X POST \
  http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d "$TEST_USER2_DATA")

if echo "$TEST_USER2_RESPONSE" | grep -q "success"; then
    print_success "Test Investor created"
else
    print_error "Failed to create Test Investor"
    echo "Response: $TEST_USER2_RESPONSE"
fi

echo ""
print_status "Step 4: Creating Businesses"
echo "----------------------------------"

# Create Kharisma Corp business
if [ -n "$KHARISMA_TOKEN" ] && [ -n "$KHARISMA_USER_ID" ]; then
    print_status "Creating Kharisma Corp business..."
    KHARISMA_CORP_DATA='{
      "name": "Kharisma Corp",
      "description": "Kharisma Corporation - A diversified business company",
      "business_type": "corporation",
      "industry": "diversified",
      "address": "Jl. Kharisma Corp No. 100, Jakarta",
      "phone": "+62-21-98765432",
      "email": "info@kharismacorp.com",
      "website": "https://kharismacorp.com",
      "registration_number": "CORP-001-2025",
      "tax_id": "TAX-CORP-001-2025",
      "bank_account": "1111111111",
      "bank_name": "Bank Kharisma",
      "annual_revenue": 1000000000,
      "employee_count": 50,
      "status": "active",
      "owner_id": "'$KHARISMA_USER_ID'"
    }'

    KHARISMA_CORP_RESPONSE=$(curl -s -X POST \
      http://localhost:8080/api/v1/businesses \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $KHARISMA_TOKEN" \
      -d "$KHARISMA_CORP_DATA")

    if echo "$KHARISMA_CORP_RESPONSE" | grep -q "success"; then
        KHARISMA_CORP_ID=$(echo "$KHARISMA_CORP_RESPONSE" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
        print_success "Kharisma Corp business created with ID: $KHARISMA_CORP_ID"
    else
        print_error "Failed to create Kharisma Corp business"
        echo "Response: $KHARISMA_CORP_RESPONSE"
    fi
else
    print_warning "Skipping business creation - Kharisma user or token not available"
fi

echo ""
print_status "Step 5: Creating Projects"
echo "--------------------------------"

# Create Pom Bensin Shell Pasteur2 project
if [ -n "$KHARISMA_TOKEN" ] && [ -n "$KHARISMA_CORP_ID" ] && [ -n "$HAJIFUND_ID" ]; then
    print_status "Creating Pom Bensin Shell Pasteur2 project..."
    SHELL_PROJECT_DATA='{
      "title": "Pom Bensin Shell Pasteur2",
      "description": "Gas station project at Pasteur2 location operated by Shell",
      "project_type": "business_expansion",
      "category": "retail",
      "funding_goal": 500000000,
      "current_funding": 0,
      "duration_days": 365,
      "location": "Jl. Pasteur No. 2, Bandung",
      "business_id": "'$KHARISMA_CORP_ID'",
      "cooperative_id": "'$HAJIFUND_ID'",
      "status": "active",
      "expected_return_rate": 15.5,
      "risk_level": "medium",
      "collateral": "Gas station equipment and land lease",
      "business_plan": "Establish a Shell-branded gas station with convenience store",
      "financial_projections": "Expected annual revenue: 2.5 billion IDR",
      "market_analysis": "High traffic location with growing vehicle ownership"
    }'

    SHELL_PROJECT_RESPONSE=$(curl -s -X POST \
      http://localhost:8080/api/v1/projects \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $KHARISMA_TOKEN" \
      -d "$SHELL_PROJECT_DATA")

    if echo "$SHELL_PROJECT_RESPONSE" | grep -q "success"; then
        SHELL_PROJECT_ID=$(echo "$SHELL_PROJECT_RESPONSE" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
        print_success "Pom Bensin Shell Pasteur2 project created with ID: $SHELL_PROJECT_ID"
    else
        print_error "Failed to create Pom Bensin Shell Pasteur2 project"
        echo "Response: $SHELL_PROJECT_RESPONSE"
    fi
else
    print_warning "Skipping project creation - required entities not available"
fi

echo ""
print_status "Step 6: Testing API Endpoints"
echo "-----------------------------------"

# Test getting all cooperatives
print_status "Testing GET /cooperatives..."
COOPERATIVES_RESPONSE=$(curl -s -H "Authorization: Bearer $ADMIN_TOKEN" http://localhost:8080/api/v1/cooperatives)
if echo "$COOPERATIVES_RESPONSE" | grep -q "success"; then
    print_success "Cooperatives endpoint working"
else
    print_error "Cooperatives endpoint failed"
fi

# Test getting public projects
print_status "Testing GET /public/projects..."
PROJECTS_RESPONSE=$(curl -s http://localhost:8080/api/v1/public/projects)
if echo "$PROJECTS_RESPONSE" | grep -q "success"; then
    print_success "Public projects endpoint working"
else
    print_error "Public projects endpoint failed"
fi

# Test getting businesses
if [ -n "$KHARISMA_TOKEN" ]; then
    print_status "Testing GET /businesses..."
    BUSINESSES_RESPONSE=$(curl -s -H "Authorization: Bearer $KHARISMA_TOKEN" http://localhost:8080/api/v1/businesses)
    if echo "$BUSINESSES_RESPONSE" | grep -q "success"; then
        print_success "Businesses endpoint working"
    else
        print_error "Businesses endpoint failed"
    fi
else
    print_warning "Skipping businesses endpoint test - no user token available"
fi

echo ""
print_status "Step 7: Summary"
echo "-------------------"

print_success "✅ Testing completed!"
echo ""
echo "📋 Created Entities Summary:"
echo "============================"
echo "🏢 Cooperatives:"
if [ -n "$HAJIFUND_ID" ]; then
    echo "   - Hajifund (ID: $HAJIFUND_ID)"
else
    echo "   - Hajifund: ❌ Not created"
fi
if [ -n "$SIDANA_ID" ]; then
    echo "   - Sidana (ID: $SIDANA_ID)"
else
    echo "   - Sidana: ❌ Not created"
fi
echo ""
echo "👥 Users:"
if [ -n "$KHARISMA_USER_ID" ]; then
    echo "   - Kharisma (ID: $KHARISMA_USER_ID) - Member of Hajifund"
else
    echo "   - Kharisma: ❌ Not created"
fi
echo "   - Test User 1 - Member of Sidana"
echo "   - Test Investor - Investor role"
echo ""
echo "🏪 Businesses:"
if [ -n "$KHARISMA_CORP_ID" ]; then
    echo "   - Kharisma Corp (ID: $KHARISMA_CORP_ID)"
else
    echo "   - Kharisma Corp: ❌ Not created"
fi
echo ""
echo "📈 Projects:"
if [ -n "$SHELL_PROJECT_ID" ]; then
    echo "   - Pom Bensin Shell Pasteur2 (ID: $SHELL_PROJECT_ID)"
else
    echo "   - Pom Bensin Shell Pasteur2: ❌ Not created"
fi
echo ""
echo "🔑 Test Credentials:"
echo "==================="
echo "Admin User:"
echo "  Email: admin-ryan@comfunds.com"
echo "  Password: AdminRyan2025!"
echo ""
echo "Kharisma User:"
echo "  Email: kharisma@hajifund.coop"
echo "  Password: Kharisma2025!"
echo ""
echo "Test User 1:"
echo "  Email: testuser1@sidana.coop"
echo "  Password: TestUser2025!"
echo ""
echo "Test Investor:"
echo "  Email: investor@comfunds.com"
echo "  Password: Investor2025!"
echo ""
echo "🌐 Web Application:"
echo "=================="
echo "URL: http://localhost:3000"
echo ""
echo "📝 Next Steps:"
echo "=============="
echo "1. Open http://localhost:3000 in your browser"
echo "2. Test login with different user types"
echo "3. Verify role-based routing (admin → admin dashboard)"
echo "4. Test project creation and management"
echo "5. Test cooperative membership features"
echo ""
print_success "🎉 Complete workflow testing script v2 finished!"
