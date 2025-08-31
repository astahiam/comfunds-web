# Admin Testing Guide

## Admin User Credentials

**Admin User:** admin-ryan  
**Email:** admin-ryan@comfunds.com  
**Password:** AdminRyan2025!  

## How to Test Admin Functionality

### 1. Access the Web Application

1. Open your browser and navigate to: `http://localhost:3000`
2. The Flutter web app should be running and accessible

### 2. Login as Admin

1. Click on "Login" in the navigation
2. Enter the admin credentials:
   - Email: `admin-ryan@comfunds.com`
   - Password: `AdminRyan2025!`
3. Click "Login"

### 3. Admin Dashboard Access

After successful login, you should be automatically redirected to the **Admin Dashboard** (`/admin-dashboard`) instead of the regular user dashboard.

### 4. Admin Dashboard Features to Test

#### Overview Section
- **Statistics Cards**: View total users, pending role requests, active projects, etc.
- **Quick Actions**: Access to common admin tasks
- **Recent Activity**: Monitor system activity

#### User Management
- **User List**: View all registered users
- **Search & Filter**: Find specific users
- **User Details**: View user information
- **Edit Users**: Modify user details (placeholder)
- **Delete Users**: Remove users (placeholder)

#### Role Requests Management
- **Pending Requests**: View role change requests
- **Request Details**: See request information
- **Approve/Reject**: Handle role requests
- **Filter by Status**: Filter requests by pending/approved/rejected

#### Role Statistics
- **Role Distribution**: Pie chart showing user role distribution
- **Recent Role Changes**: Timeline of role modifications
- **Analytics**: Role-based analytics

#### System Settings
- **Role Request Settings**: Enable/disable role requests
- **Auto-approval**: Configure automatic role approval
- **Notifications**: Manage system notifications
- **2FA Settings**: Two-factor authentication configuration

### 5. Admin Registration Testing

#### Test Admin Registration Page
1. Go to the regular registration page (`/register`)
2. Click on "Admin Registration" link
3. You'll be redirected to `/admin-register`

#### Admin Registration Features
- **Admin Authorization Code**: Required field (use: `ADMIN2025`)
- **Enhanced Security**: Additional validation for admin accounts
- **Role Selection**: Choose from admin roles (admin, cooperative_admin)
- **Password Requirements**: Strong password validation

### 6. Role-Based Routing Test

#### Admin User Flow
1. Login as admin-ryan
2. Should be redirected to `/admin-dashboard`
3. Navigation should show admin-specific options

#### Regular User Flow
1. Register a regular user (member, investor, business_owner)
2. Login with regular user
3. Should be redirected to `/dashboard` (regular user dashboard)

### 7. API Integration Testing

#### Backend Connection
- Verify the app connects to `http://localhost:8080`
- Test API endpoints through the admin interface
- Check for proper error handling

#### Role Management API
- Test role request creation
- Test role approval/rejection
- Test user role updates

### 8. Security Testing

#### Admin Access Control
- Verify only admin users can access admin dashboard
- Test role-based permissions
- Verify admin authorization code requirement

#### Session Management
- Test login/logout functionality
- Verify token storage and refresh
- Test session timeout

## Test Scenarios

### Scenario 1: Admin Login and Dashboard Access
1. Login as admin-ryan
2. Verify redirection to admin dashboard
3. Check all admin features are accessible

### Scenario 2: User Management
1. Access User Management section
2. View user list
3. Test search and filter functionality
4. Verify user details display

### Scenario 3: Role Request Approval
1. Create a role request (if backend supports it)
2. Access Role Requests section
3. Test approve/reject functionality
4. Verify status updates

### Scenario 4: Admin Registration
1. Access admin registration page
2. Test with invalid admin code
3. Test with valid admin code (`ADMIN2025`)
4. Verify admin user creation

### Scenario 5: Role-Based Navigation
1. Login as different user types
2. Verify correct dashboard routing
3. Test navigation menu differences

## Expected Behaviors

### Admin Dashboard
- Should load without errors
- All sections should be accessible
- Data should display properly (even if placeholder)
- Navigation should work correctly

### Error Handling
- Invalid credentials should show error message
- Network errors should be handled gracefully
- Missing permissions should redirect appropriately

### Responsive Design
- Dashboard should work on different screen sizes
- Mobile navigation should be functional
- UI should be consistent across devices

## Troubleshooting

### Common Issues

1. **Login Fails**
   - Verify backend is running on port 8080
   - Check credentials are correct
   - Verify API endpoints are accessible

2. **Admin Dashboard Not Loading**
   - Check browser console for errors
   - Verify user has admin role
   - Check network connectivity

3. **Role-Based Routing Issues**
   - Verify user roles are properly set
   - Check app.dart routing logic
   - Verify AuthProvider state management

### Debug Steps

1. Check browser developer tools console
2. Verify API responses in Network tab
3. Check Flutter debug output
4. Verify backend logs

## Success Criteria

✅ Admin user can login successfully  
✅ Admin dashboard loads and displays correctly  
✅ Role-based routing works (admin → admin dashboard)  
✅ All admin sections are accessible  
✅ Admin registration page works with authorization code  
✅ User management interface displays  
✅ Role request management interface displays  
✅ System settings interface displays  
✅ Responsive design works on different screen sizes  
✅ Error handling works properly  

## Notes

- Some features may show placeholder data initially
- Backend integration may need additional endpoints
- UI/UX can be enhanced based on testing feedback
- Performance optimization may be needed for large datasets
