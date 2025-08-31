#!/bin/bash

# Create Kharisma Entities Script - Final Version
# This script logs in as Kharisma and creates business and project

echo "🚀 Creating Kharisma Entities - Final Version"
echo "============================================="

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

echo ""
print_status "Step 1: Login as Kharisma"
echo "-------------------------------"

# Login as Kharisma
print_status "Logging in as Kharisma..."
KHARISMA_LOGIN_DATA='{
  "email": "kharisma@hajifund.coop",
  "password": "Kharisma2025!"
}'

KHARISMA_LOGIN_RESPONSE=$(curl -s -X POST \
  http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d "$KHARISMA_LOGIN_DATA")

if echo "$KHARISMA_LOGIN_RESPONSE" | grep -q "success"; then
    KHARISMA_TOKEN=$(echo "$KHARISMA_LOGIN_RESPONSE" | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)
    KHARISMA_USER_ID=$(echo "$KHARISMA_LOGIN_RESPONSE" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
    print_success "Kharisma login successful"
    print_status "Kharisma token obtained"
    print_status "Kharisma User ID: $KHARISMA_USER_ID"
else
    print_error "Kharisma login failed"
    echo "Response: $KHARISMA_LOGIN_RESPONSE"
    exit 1
fi

echo ""
print_status "Step 2: Get Cooperative IDs"
echo "---------------------------------"

# Login as admin to get cooperative IDs
print_status "Logging in as admin to get cooperative IDs..."
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
    
    # Get cooperatives
    COOPERATIVES_RESPONSE=$(curl -s -H "Authorization: Bearer $ADMIN_TOKEN" http://localhost:8080/api/v1/cooperatives)
    if echo "$COOPERATIVES_RESPONSE" | grep -q "Hajifund"; then
        HAJIFUND_ID=$(echo "$COOPERATIVES_RESPONSE" | grep -A 20 "Hajifund" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
        print_success "Found Hajifund Cooperative ID: $HAJIFUND_ID"
    else
        print_error "Could not find Hajifund cooperative"
        HAJIFUND_ID=""
    fi
    
    if echo "$COOPERATIVES_RESPONSE" | grep -q "Sidana"; then
        SIDANA_ID=$(echo "$COOPERATIVES_RESPONSE" | grep -A 20 "Sidana" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
        print_success "Found Sidana Cooperative ID: $SIDANA_ID"
    else
        print_error "Could not find Sidana cooperative"
        SIDANA_ID=""
    fi
else
    print_error "Admin login failed"
    exit 1
fi

echo ""
print_status "Step 3: Creating Kharisma Corp Business"
echo "----------------------------------------------"

# Create Kharisma Corp business with correct date format
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
      "owner_id": "'$KHARISMA_USER_ID'",
      "type": "corporation",
      "legal_structure": "PT",
      "established_date": "2020-01-01T00:00:00Z",
      "currency": "IDR"
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
print_status "Step 4: Creating Pom Bensin Shell Pasteur2 Project"
echo "---------------------------------------------------------"

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
    if [ -z "$KHARISMA_TOKEN" ]; then
        print_error "Missing Kharisma token"
    fi
    if [ -z "$KHARISMA_CORP_ID" ]; then
        print_error "Missing Kharisma Corp ID"
    fi
    if [ -z "$HAJIFUND_ID" ]; then
        print_error "Missing Hajifund ID"
    fi
fi

echo ""
print_status "Step 5: Summary"
echo "-------------------"

print_success "✅ Kharisma entities creation completed!"
echo ""
echo "📋 Created Entities Summary:"
echo "============================"
echo "👤 Kharisma User:"
echo "   - ID: $KHARISMA_USER_ID"
echo "   - Email: kharisma@hajifund.coop"
echo "   - Member of Hajifund Cooperative"
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
echo "Kharisma User:"
echo "  Email: kharisma@hajifund.coop"
echo "  Password: Kharisma2025!"
echo ""
echo "🌐 Web Application:"
echo "=================="
echo "URL: http://localhost:3000"
echo ""
echo "📝 Next Steps:"
echo "=============="
echo "1. Open http://localhost:3000 in your browser"
echo "2. Login as Kharisma to test business and project features"
echo "3. Test project creation and management"
echo "4. Test cooperative membership features"
echo ""
print_success "🎉 Kharisma entities creation script final version finished!"
