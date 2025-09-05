# 🧪 **New Features UI Testing Checklist**

## 🎯 **Testing Overview**
This document provides a systematic approach to test all the new features implemented in the ComFunds platform:
- Project Approval Workflow for Cooperative Admins
- Investment Functionality for Cooperative Members
- Enhanced Dashboard Navigation
- Business Creation Flow

## 🌐 **Application Access**
- **URL**: http://localhost:3000
- **Browser**: Google Chrome
- **Status**: ✅ Running

## 🔐 **Test User Accounts Needed**

### **1. Admin ComFunds User**
- **Email**: admin-ryan@comfunds.com
- **Password**: AdminRyan2025!
- **Role**: admin_comfunds
- **Purpose**: Test admin registration and role assignment

### **2. Admin Cooperative User**
- **Email**: admin-coop@comfunds.com
- **Password**: AdminCoop2025!
- **Role**: admin_cooperative
- **Purpose**: Test project approval workflow

### **3. Regular Member User**
- **Email**: member@comfunds.com
- **Password**: Member2025!
- **Role**: member
- **Purpose**: Test investment functionality

### **4. Business Owner User**
- **Email**: business@comfunds.com
- **Password**: Business2025!
- **Role**: business_owner
- **Purpose**: Test business and project creation

## 📋 **Test Scenarios**

### **Phase 1: User Registration & Authentication**

#### **1.1 Admin Registration**
- [ ] Navigate to `/admin-register`
- [ ] Fill in admin registration form
- [ ] Select admin role (admin_comfunds, admin_cooperative, umkm_business)
- [ ] Enter admin authorization code
- [ ] Submit registration
- [ ] Verify successful registration
- [ ] Verify role assignment

#### **1.2 Regular User Registration**
- [ ] Navigate to `/register`
- [ ] Fill in user registration form
- [ ] Select member role
- [ ] Submit registration
- [ ] Verify successful registration
- [ ] Verify role assignment

#### **1.3 User Login**
- [ ] Navigate to `/login`
- [ ] Login with test accounts
- [ ] Verify correct dashboard routing based on roles
- [ ] Verify authentication state persistence

### **Phase 2: Dashboard Navigation & Role-Based Access**

#### **2.1 Admin ComFunds Dashboard**
- [ ] Login as admin_comfunds user
- [ ] Verify routing to `/admin-dashboard`
- [ ] Check sidebar navigation options
- [ ] Verify user management features
- [ ] Verify role assignment capabilities

#### **2.2 Admin Cooperative Dashboard**
- [ ] Login as admin_cooperative user
- [ ] Verify routing to `/cooperative-admin-dashboard`
- [ ] Check sidebar navigation options
- [ ] Verify cooperative management features
- [ ] Verify project approval workflow access

#### **2.3 Regular Member Dashboard**
- [ ] Login as member user
- [ ] Verify routing to `/dashboard`
- [ ] Check sidebar navigation options
- [ ] Verify investment tab availability
- [ ] Verify business creation tab availability

### **Phase 3: Business Creation Flow**

#### **3.1 Business Creation Screen**
- [ ] Navigate to `/create-business` or use dashboard tab
- [ ] Fill in business creation form
- [ ] Select cooperative (if user is member of one)
- [ ] Enter business details (name, type, industry, etc.)
- [ ] Submit business creation
- [ ] Verify successful creation
- [ ] Verify business status (pending approval)

#### **3.2 Business Management**
- [ ] View created businesses in dashboard
- [ ] Check business status and details
- [ ] Verify cooperative association

### **Phase 4: Project Creation & Management**

#### **4.1 Project Creation**
- [ ] Login as business owner
- [ ] Create new project
- [ ] Fill in project details (title, description, funding goal)
- [ ] Set profit sharing ratios
- [ ] Submit project
- [ ] Verify project status (draft)

#### **4.2 Project Submission**
- [ ] Submit project for approval
- [ ] Verify status change to "submitted"
- [ ] Verify admin notification

### **Phase 5: Project Approval Workflow**

#### **5.1 Admin Project Review**
- [ ] Login as admin_cooperative user
- [ ] Navigate to Projects section
- [ ] View submitted projects
- [ ] Check project details and information
- [ ] Verify approval/rejection options available

#### **5.2 Project Approval**
- [ ] Select project for approval
- [ ] Click "Approve" button
- [ ] Verify status change to "approved"
- [ ] Verify success notification

#### **5.3 Project Rejection**
- [ ] Select project for rejection
- [ ] Click "Reject" button
- [ ] Enter rejection reason
- [ ] Submit rejection
- [ ] Verify status change to "rejected"
- [ ] Verify rejection reason is recorded

#### **5.4 Investment Process Control**
- [ ] For approved projects, verify "Start Investment" option
- [ ] Click "Start Investment" for approved project
- [ ] Verify status change to "active"
- [ ] Verify success notification

#### **5.5 Project Closure**
- [ ] For active projects, verify "Close Funding" option
- [ ] Click "Close Funding" for active project
- [ ] Verify status change to "closed"
- [ ] Verify success notification

### **Phase 6: Investment Functionality**

#### **6.1 Available Projects View**
- [ ] Login as member user
- [ ] Navigate to Investments tab
- [ ] View available projects for investment
- [ ] Verify project information display
- [ ] Verify funding progress visualization

#### **6.2 Investment Creation**
- [ ] Select project for investment
- [ ] Click "Invest Now" button
- [ ] Enter investment amount
- [ ] Submit investment
- [ ] Verify investment creation
- [ ] Verify success notification

#### **6.3 Investment Validation**
- [ ] Try to invest more than available funding
- [ ] Verify error message for excessive amount
- [ ] Try to invest in closed projects
- [ ] Verify error message for closed projects

#### **6.4 Portfolio Management**
- [ ] Navigate to "My Investments" tab
- [ ] View investment portfolio
- [ ] Check investment status and details
- [ ] Verify investment history

#### **6.5 Investment Withdrawal**
- [ ] Select pending investment
- [ ] Click "Withdraw" option
- [ ] Enter withdrawal reason (optional)
- [ ] Submit withdrawal
- [ ] Verify withdrawal success
- [ ] Verify status change

### **Phase 7: Enhanced UI Features**

#### **7.1 Project Cards**
- [ ] Verify status indicators (color-coded chips)
- [ ] Check progress bars for funding
- [ ] Verify action menus based on status
- [ ] Check detailed project information

#### **7.2 Navigation & Layout**
- [ ] Verify responsive design
- [ ] Check sidebar navigation functionality
- [ ] Verify tab switching
- [ ] Check mobile-friendly layout

#### **7.3 Error Handling**
- [ ] Test with invalid data inputs
- [ ] Verify error messages display
- [ ] Check form validation
- [ ] Test network error scenarios

## 🐛 **Known Issues to Monitor**

### **Backend Integration**
- [ ] API endpoint availability
- [ ] Response format compatibility
- [ ] Authentication token handling
- [ ] Error response parsing

### **Data Persistence**
- [ ] State management across navigation
- [ ] Data refresh after actions
- [ ] Cache invalidation
- [ ] Real-time updates

### **Performance**
- [ ] Page load times
- [ ] API response times
- [ ] UI responsiveness
- [ ] Memory usage

## 📊 **Test Results Tracking**

### **Feature Status**
- ✅ **Working**: Feature functions as expected
- ⚠️ **Partial**: Feature works with limitations
- ❌ **Broken**: Feature does not work
- 🔄 **In Progress**: Feature being tested

### **Test Results Template**
```
Feature: [Feature Name]
Status: [Working/Partial/Broken/In Progress]
Notes: [Any observations or issues]
Screenshots: [If applicable]
```

## 🚀 **Next Steps After Testing**

1. **Document Issues**: Record any bugs or limitations found
2. **Prioritize Fixes**: Identify critical vs. minor issues
3. **Performance Analysis**: Note any performance concerns
4. **User Experience**: Identify UX improvements needed
5. **Backend Integration**: Note any API compatibility issues

## 📝 **Testing Notes**

- **Browser**: Chrome 139.0.7258.128
- **Flutter Version**: Latest stable
- **Test Environment**: Local development
- **Backend Status**: Should be running on localhost:8080
- **Test Data**: Use provided test accounts or create new ones

---

**Happy Testing! 🎉**
Please update this document with your findings as you test each feature.
