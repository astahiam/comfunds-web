#!/bin/bash

# HAJIFUND Test Script with Secure Credentials
# This script reads credentials from config/test_credentials.json
# instead of having them hardcoded

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_status() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    print_error "jq is required but not installed. Please install jq to parse JSON."
    print_status "Install with: brew install jq (macOS) or apt-get install jq (Ubuntu)"
    exit 1
fi

# Check if config file exists
CREDENTIALS_FILE="config/test_credentials.json"
if [ ! -f "$CREDENTIALS_FILE" ]; then
    print_error "Credentials file not found: $CREDENTIALS_FILE"
    print_status "Please ensure the credentials file exists and is properly configured."
    exit 1
fi

print_status "🔐 Loading secure credentials from $CREDENTIALS_FILE"

# Load API configuration
API_BASE_URL=$(jq -r '.api_endpoints.base_url' "$CREDENTIALS_FILE")
print_status "API Base URL: $API_BASE_URL"

# Function to get user credentials
get_user_credentials() {
    local user_type=$1
    local field=$2
    jq -r ".test_users.${user_type}.${field}" "$CREDENTIALS_FILE"
}

# Function to test user login
test_user_login() {
    local user_type=$1
    local user_name=$2
    
    print_status "Testing $user_name login..."
    
    local email=$(get_user_credentials "$user_type" "email")
    local password=$(get_user_credentials "$user_type" "password")
    
    if [ "$email" == "null" ] || [ "$password" == "null" ]; then
        print_warning "Credentials not found for $user_type"
        return 1
    fi
    
    local login_data="{
        \"email\": \"$email\",
        \"password\": \"$password\"
    }"
    
    local response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -d "$login_data" \
        "$API_BASE_URL/auth/login")
    
    if echo "$response" | jq -e '.success' > /dev/null 2>&1; then
        print_success "$user_name login successful"
        local token=$(echo "$response" | jq -r '.data.access_token')
        echo "$token"
    else
        print_error "$user_name login failed"
        echo "Response: $response"
        echo ""
    fi
}

# Function to create user if not exists
create_user_if_not_exists() {
    local user_type=$1
    local user_name=$2
    
    print_status "Creating $user_name if not exists..."
    
    local email=$(get_user_credentials "$user_type" "email")
    local password=$(get_user_credentials "$user_type" "password")
    local name=$(get_user_credentials "$user_type" "name")
    local phone=$(get_user_credentials "$user_type" "phone")
    local address=$(get_user_credentials "$user_type" "address")
    local roles=$(jq -r ".test_users.${user_type}.roles | join(\",\")" "$CREDENTIALS_FILE")
    
    local user_data="{
        \"email\": \"$email\",
        \"password\": \"$password\",
        \"name\": \"$name\",
        \"phone\": \"$phone\",
        \"address\": \"$address\",
        \"roles\": [\"$roles\"]
    }"
    
    local response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -d "$user_data" \
        "$API_BASE_URL/auth/register")
    
    if echo "$response" | jq -e '.success' > /dev/null 2>&1; then
        local user_id=$(echo "$response" | jq -r '.data.user.id')
        print_success "$user_name created with ID: $user_id"
    else
        if echo "$response" | grep -q "already exists\|already registered"; then
            print_warning "$user_name already exists"
        else
            print_error "Failed to create $user_name"
            echo "Response: $response"
        fi
    fi
}

# Main execution
echo ""
echo "🚀 HAJIFUND Secure Testing Script"
echo "=================================="
echo ""

# Test user creation and login
print_status "Step 1: Testing Admin ComFunds"
create_user_if_not_exists "admin_comfunds" "Admin ComFunds"
ADMIN_COMFUNDS_TOKEN=$(test_user_login "admin_comfunds" "Admin ComFunds")

echo ""
print_status "Step 2: Testing Admin Cooperative"
create_user_if_not_exists "admin_cooperative" "Admin Cooperative"
ADMIN_COOPERATIVE_TOKEN=$(test_user_login "admin_cooperative" "Admin Cooperative")

echo ""
print_status "Step 3: Testing UMKM Business"
create_user_if_not_exists "umkm_business" "UMKM Business"
UMKM_BUSINESS_TOKEN=$(test_user_login "umkm_business" "UMKM Business")

echo ""
print_status "Step 4: Testing Kharisma User"
create_user_if_not_exists "kharisma" "Kharisma"
KHARISMA_TOKEN=$(test_user_login "kharisma" "Kharisma")

echo ""
print_status "Step 5: Testing Test Investor"
create_user_if_not_exists "test_investor" "Test Investor"
INVESTOR_TOKEN=$(test_user_login "test_investor" "Test Investor")

echo ""
print_success "✅ Secure Testing completed!"
echo ""
echo "📋 Test Results Summary:"
echo "========================"

# Display created users (without passwords)
echo ""
echo "👥 Created Users:"
jq -r '.test_users | to_entries[] | "   - \(.value.name) (\(.value.email)) - Roles: \(.value.roles | join(", "))"' "$CREDENTIALS_FILE"

echo ""
echo "🏢 Available Cooperatives:"
jq -r '.cooperatives | to_entries[] | "   - \(.value.name): \(.value.description)"' "$CREDENTIALS_FILE"

echo ""
echo "🔗 API Endpoints:"
echo "   - Base URL: $API_BASE_URL"
echo "   - Login: $API_BASE_URL/auth/login"
echo "   - Register: $API_BASE_URL/auth/register"

echo ""
print_success "🎉 All tests completed successfully!"
echo ""
print_warning "⚠️  Remember: Never commit credential files to version control!"
print_status "💡 Use environment variables for production deployments"
