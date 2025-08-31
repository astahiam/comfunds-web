#!/bin/bash

# Create Admin User Script for ComFunds
# This script creates an admin user named "admin-ryan"

echo "Creating admin user: admin-ryan"

# Admin user registration data
ADMIN_DATA='{
  "email": "admin-ryan@comfunds.com",
  "password": "AdminRyan2025!",
  "name": "Ryan Admin",
  "phone": "+1234567890",
  "address": "123 Admin Street, Admin City, AC 12345",
  "roles": ["admin"]
}'

echo "Registering admin user..."
echo "Data: $ADMIN_DATA"

# Register the admin user
RESPONSE=$(curl -s -X POST \
  http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d "$ADMIN_DATA")

echo "Response: $RESPONSE"

# Check if registration was successful
if echo "$RESPONSE" | grep -q "user"; then
    echo "✅ Admin user 'admin-ryan' created successfully!"
    echo "Email: admin-ryan@comfunds.com"
    echo "Password: AdminRyan2025!"
    echo ""
    echo "You can now login to the admin dashboard with these credentials."
else
    echo "❌ Failed to create admin user"
    echo "Error response: $RESPONSE"
fi

echo ""
echo "Admin user creation script completed."
