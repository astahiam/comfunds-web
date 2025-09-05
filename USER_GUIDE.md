# 📖 ComFunds Platform User Guide

Welcome to ComFunds - the Islamic P2P (Peer-to-Peer) Lending Syariah platform that connects pendana (funders) with peminjam (borrowers) based on Sharia-compliant principles. This comprehensive guide will walk you through all the main workflows and features of our P2P lending platform.

## 📋 Table of Contents

1. [Getting Started](#-getting-started)
2. [User Roles Overview](#-user-roles-overview)
3. [Pendana (Funder) Workflow](#-pendana-funder-workflow)
4. [Peminjam (Borrower) Workflow](#-peminjam-borrower-workflow)
5. [Platform Admin Workflow](#-platform-admin-workflow)
6. [Complete P2P Lending Cycle](#-complete-p2p-lending-cycle)
7. [Sharia Compliance](#-sharia-compliance)
8. [Investment Calculator](#-investment-calculator)
9. [Troubleshooting](#-troubleshooting)

---

## 🚀 Getting Started

### Accessing the Platform
1. Open your web browser and navigate to the ComFunds P2P Lending platform (http://localhost:3002)
2. You'll see the HAJIFUND-inspired landing page with P2P lending overview and Islamic finance features
3. Click **"Mulai Investasi Sekarang"** (Start Investing Now) to create an account or **"Masuk"** (Login) if you already have one

### Registration Process

#### For P2P Lending Users (Pendana/Peminjam)
1. Click **"Mulai Investasi Sekarang"** on the landing page
2. Fill in your personal information:
   - Full Name
   - Email Address
   - Phone Number
   - Address
   - Strong Password (with Sharia-compliant requirements)
3. Select your role(s):
   - **Pendana**: Fund Islamic P2P lending projects
   - **Peminjam**: Apply for Sharia-compliant business funding
   - **Member**: Basic platform member
4. Click **"Daftar Sekarang"** (Register Now)
5. You'll be redirected to the P2P lending dashboard upon successful registration

#### For Platform Administrators
1. Navigate to `/comfunds-admin-register` (special URL)
2. Enter the **ComFunds Admin Authorization Code**: `COMFUNDS2025`
3. Fill in administrator information
4. Complete registration process
5. Login with your credentials to access P2P lending management dashboard

---

## 👥 User Roles Overview

### 🏠 Regular Users
- **Member**: Basic cooperative member with access to view projects and participate in community
- **Business Owner**: Can create businesses and submit project proposals
- **Investor**: Can browse and invest in approved projects within their cooperative

### 🏛️ Administrators
- **Cooperative Admin**: Manages a specific cooperative, reviews business proposals, approves projects
- **ComFunds Admin**: Platform-wide administrator with full system access

---

## 👤 Regular User Workflow

### Initial Setup
1. **Register** as a regular user with appropriate roles
2. **Login** to access your dashboard
3. **Complete Profile** if additional information is needed

### For Members/Investors

#### 1. Browsing Investment Opportunities
```
Dashboard → Projects Tab → Browse Available Projects
```
- View all approved projects within your cooperative
- Filter by funding status, project type, or business
- Check project details, funding goals, and timelines

#### 2. Making an Investment
```
Projects → Select Project → View Details → Invest Button
```
1. Click on a project you're interested in
2. Review project details:
   - Business information
   - Funding goal and current progress
   - Expected returns and timeline
   - Risk assessment
3. Click **"Invest"**
4. Enter investment amount
5. Review and confirm investment terms
6. Submit investment request

#### 3. Tracking Your Investments
```
Dashboard → Investments Tab
```
- View all your active investments
- Monitor project progress
- Track expected returns
- View investment history

### For Business Owners

#### 1. Creating a Business
```
Dashboard → Create Business Tab
```
1. Click **"Create New Business"**
2. Fill in business details:
   - Business name and type
   - Industry and description
   - Contact information
   - Registration documents
   - Financial information
3. Submit for cooperative admin review
4. Wait for approval notification

#### 2. Managing Your Businesses
```
Dashboard → Businesses Tab
```
- View all your businesses and their status
- Edit business information (if not yet approved)
- Monitor business approval process

---

## 🏛️ Cooperative Admin Workflow

### Dashboard Overview
```
Login → Cooperative Admin Dashboard
```
The cooperative admin dashboard provides:
- Business approval queue
- Project approval queue
- Member management
- Investment oversight
- Financial reports

### 1. Reviewing Business Applications
```
Dashboard → Business Applications Tab
```
1. **Review New Applications**:
   - Check business documentation
   - Verify registration information
   - Assess business viability
   
2. **Approval Process**:
   - Click **"Review"** on pending business
   - Evaluate all submitted documents
   - Choose **"Approve"** or **"Reject"**
   - Add approval/rejection notes
   - Notify business owner of decision

### 2. Managing Project Proposals
```
Dashboard → Project Proposals Tab
```
1. **Review Project Submissions**:
   - Evaluate project feasibility
   - Check funding requirements
   - Assess risk levels
   - Review business owner's track record

2. **Project Approval**:
   - Set project visibility (publish to investment board)
   - Configure investment parameters
   - Set project timeline and milestones
   - Approve for public investment

### 3. Investment Management
```
Dashboard → Investments Tab
```
1. **Monitor Active Investments**:
   - Track investment flows
   - Monitor project progress
   - Oversee fund disbursements

2. **Fee and Return Distribution**:
   - Calculate cooperative fees
   - Process profit distributions
   - Manage investor payouts
   - Generate financial reports

### 4. Member Management
```
Dashboard → Members Tab
```
- View all cooperative members
- Manage member roles and permissions
- Handle member inquiries and issues
- Generate membership reports

---

## 🏢 Business Owner Workflow

### Getting Started as Business Owner
1. **Register** with "Business Owner" role
2. **Create your first business** (requires cooperative admin approval)
3. **Wait for business approval**
4. **Start creating projects** once approved

### 1. Business Creation Process
```
Dashboard → Create Business
```
1. **Basic Information**:
   - Business name and description
   - Business type and industry
   - Contact details

2. **Legal Information**:
   - Registration number
   - Tax identification
   - Business address

3. **Financial Details**:
   - Bank account information
   - Annual revenue (estimated)
   - Number of employees

4. **Documentation**:
   - Upload business registration
   - Provide additional supporting documents
   - Submit for review

### 2. Project Creation Workflow
```
Dashboard → Create Project (after business approval)
```
1. **Project Basics**:
   - Project title and description
   - Select associated business
   - Project type and category

2. **Financial Planning**:
   - Set funding goal
   - Define minimum investment amount
   - Set funding deadline
   - Specify profit-sharing percentage

3. **Project Details**:
   - Add project milestones
   - Upload project documents
   - Set project timeline
   - Define success metrics

4. **Review and Submit**:
   - Review all information
   - Submit to cooperative admin
   - Wait for approval

### 3. Managing Active Projects
```
Dashboard → My Projects
```
1. **Project Monitoring**:
   - Track funding progress
   - View investor list
   - Monitor milestone completion
   - Update project status

2. **Investor Communication**:
   - Send project updates
   - Share milestone achievements
   - Communicate any delays or issues

3. **Financial Management**:
   - Receive approved funding
   - Pay cooperative fees
   - Distribute profits to investors
   - Maintain financial transparency

---

## 🔧 ComFunds Admin Workflow

### Platform Management
```
ComFunds Admin Dashboard
```

### 1. System Oversight
- **User Management**: View and manage all platform users
- **Cooperative Management**: Oversee all cooperatives
- **Platform Analytics**: Monitor platform-wide metrics
- **System Configuration**: Manage platform settings

### 2. Cooperative Administration
1. **Create New Cooperatives**
2. **Assign Cooperative Admins**
3. **Monitor Cooperative Performance**
4. **Handle Escalated Issues**

### 3. Platform Maintenance
- **User Support**: Handle complex user issues
- **System Updates**: Manage platform updates
- **Security**: Monitor and maintain platform security
- **Reporting**: Generate platform-wide reports

---

## 🔄 Complete Investment Cycle

### Phase 1: Business Setup
```
Business Owner → Creates Business → Cooperative Admin Reviews → Business Approved
```

### Phase 2: Project Creation
```
Business Owner → Creates Project → Cooperative Admin Reviews → Project Published
```

### Phase 3: Investment Phase
```
Investors → Browse Projects → Make Investments → Funds Collected
```

### Phase 4: Fund Disbursement
```
Cooperative Admin → Disburses Funds → Business Receives Capital → Project Execution
```

### Phase 5: Profit Distribution
```
Business Generates Profit → Pays Cooperative Fee → Distributes Returns → Investors Receive Profits
```

### Detailed Investment Cycle

#### Step 1: Project Goes Live
1. **Cooperative admin approves project**
2. **Project appears on investment board**
3. **Investors can start investing**

#### Step 2: Investment Collection
1. **Investors browse available projects**
2. **Make investment decisions**
3. **Funds held in cooperative account**
4. **Investment tracking begins**

#### Step 3: Fund Release
1. **Funding goal reached or deadline met**
2. **Cooperative admin reviews final approval**
3. **Funds released to business owner**
4. **Cooperative fee deducted**

#### Step 4: Project Execution
1. **Business owner executes project**
2. **Regular progress updates provided**
3. **Milestone tracking and reporting**

#### Step 5: Profit Generation & Distribution
1. **Business generates profits**
2. **Profit-sharing calculation based on agreement**
3. **Business pays returns to cooperative**
4. **Cooperative admin distributes to investors**
5. **Platform fee retained by cooperative**

---

## 🎯 Key Features by User Type

### For Investors
- ✅ Browse investment opportunities
- ✅ Track investment portfolio
- ✅ Monitor project progress
- ✅ Receive profit distributions
- ✅ View investment history

### For Business Owners
- ✅ Create and manage businesses
- ✅ Submit project proposals
- ✅ Access funding for projects
- ✅ Communicate with investors
- ✅ Manage profit distributions

### For Cooperative Admins
- ✅ Review and approve businesses
- ✅ Evaluate project proposals
- ✅ Manage investment flows
- ✅ Distribute fees and returns
- ✅ Oversee cooperative members

### For ComFunds Admins
- ✅ Platform-wide management
- ✅ Cooperative oversight
- ✅ User administration
- ✅ System analytics
- ✅ Platform configuration

---

## 🛠️ Troubleshooting

### Common Issues

#### Registration Problems
- **Issue**: Can't complete registration
- **Solution**: Check password requirements and ensure all fields are filled
- **Contact**: Use contact form or email support

#### Login Issues
- **Issue**: Forgot password
- **Solution**: Use "Forgot Password" link on login page
- **Alternative**: Contact cooperative admin or platform support

#### Investment Issues
- **Issue**: Can't invest in a project
- **Solution**: Check if you're a member of the same cooperative and have sufficient funds
- **Contact**: Contact cooperative admin for assistance

#### Business/Project Approval Delays
- **Issue**: Business or project not approved
- **Solution**: Contact your cooperative admin for status update
- **Check**: Ensure all required documents are submitted

### Getting Help

#### For Regular Users
1. **Contact Cooperative Admin**: For business/investment issues
2. **Platform Support**: For technical issues
3. **User Guide**: Reference this document

#### For Admins
1. **ComFunds Support**: For platform-related issues
2. **Admin Documentation**: Reference admin-specific guides
3. **Platform Updates**: Check for system announcements

---

## 📞 Support Contact

### For Technical Issues
- **Email**: support@comfunds.com
- **Platform**: Use in-app contact form

### For Business/Investment Issues
- **Contact**: Your cooperative administrator
- **Alternative**: Platform support for escalation

### For Platform Administration
- **Email**: admin@comfunds.com
- **Phone**: Available for ComFunds admins

---

## 📝 Quick Reference

### Important URLs
- **Main Platform**: `/`
- **User Registration**: `/register`
- **ComFunds Admin Registration**: `/comfunds-admin-register`
- **Login**: `/login`
- **Dashboard**: `/dashboard`

### Key Actions
- **Create Business**: Dashboard → Create Business Tab
- **Create Project**: Dashboard → Create Project (after business approval)
- **Make Investment**: Projects → Select Project → Invest
- **View Portfolio**: Dashboard → Investments Tab

### Authorization Codes
- **ComFunds Admin Code**: `COMFUNDS2025` (for platform administrators only)

---

*This guide covers the main workflows of the ComFunds platform. For specific technical issues or additional features, please contact platform support or refer to the detailed system documentation.*

**Last Updated**: January 2025  
**Version**: 1.0
