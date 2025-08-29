import 'package:flutter_test/flutter_test.dart';
import 'package:comfunds_web/models/user.dart';
import 'package:comfunds_web/models/cooperative.dart';
import 'package:comfunds_web/models/business.dart';
import 'package:comfunds_web/models/project.dart';
import 'package:comfunds_web/models/investment.dart';
import 'package:comfunds_web/models/profit_distribution.dart';
import 'package:comfunds_web/services/api_service.dart';
import 'package:comfunds_web/services/auth_service.dart';
import 'package:comfunds_web/services/cooperative_service.dart';
import 'package:comfunds_web/services/business_service.dart';
import 'package:comfunds_web/services/project_service.dart';
import 'package:comfunds_web/services/investment_service.dart';

void main() {
  group('Model Tests', () {
    group('User Model', () {
      test('should create user from JSON', () {
        final json = {
          'id': '1',
          'email': 'test@example.com',
          'name': 'Test User',
          'phone': '+6281234567890',
          'address': 'Test Address',
          'cooperative_id': 'coop-1',
          'roles': ['member', 'investor'],
          'kyc_status': 'verified',
          'is_active': true,
          'created_at': '2024-01-01T00:00:00Z',
          'updated_at': '2024-01-01T00:00:00Z',
          'user_profile_image': 'profile.jpg',
        };

        final user = User.fromJson(json);

        expect(user.id, '1');
        expect(user.email, 'test@example.com');
        expect(user.name, 'Test User');
        expect(user.phone, '+6281234567890');
        expect(user.address, 'Test Address');
        expect(user.cooperativeId, 'coop-1');
        expect(user.roles, ['member', 'investor']);
        expect(user.kycStatus, 'verified');
        expect(user.isActive, true);
        expect(user.userProfileImage, 'profile.jpg');
      });

      test('should convert user to JSON', () {
        final user = User(
          id: '1',
          email: 'test@example.com',
          name: 'Test User',
          phone: '+6281234567890',
          address: 'Test Address',
          cooperativeId: 'coop-1',
          roles: ['member', 'investor'],
          kycStatus: 'verified',
          isActive: true,
          createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
          updatedAt: DateTime.parse('2024-01-01T00:00:00Z'),
          userProfileImage: 'profile.jpg',
        );

        final json = user.toJson();

        expect(json['id'], '1');
        expect(json['email'], 'test@example.com');
        expect(json['name'], 'Test User');
        expect(json['phone'], '+6281234567890');
        expect(json['address'], 'Test Address');
        expect(json['cooperative_id'], 'coop-1');
        expect(json['roles'], ['member', 'investor']);
        expect(json['kyc_status'], 'verified');
        expect(json['is_active'], true);
        expect(json['user_profile_image'], 'profile.jpg');
      });

      test('should check user roles correctly', () {
        final user = User(
          id: '1',
          email: 'test@example.com',
          name: 'Test User',
          roles: ['member', 'investor', 'business_owner'],
          kycStatus: 'verified',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(user.hasRole('member'), true);
        expect(user.hasRole('investor'), true);
        expect(user.hasRole('business_owner'), true);
        expect(user.hasRole('admin'), false);
        expect(user.isGuest, false);
        expect(user.isMember, true);
        expect(user.isInvestor, true);
        expect(user.isBusinessOwner, true);
        expect(user.isAdmin, false);
      });

      test('should copy user with changes', () {
        final user = User(
          id: '1',
          email: 'test@example.com',
          name: 'Test User',
          roles: ['member'],
          kycStatus: 'pending',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final updatedUser = user.copyWith(
          name: 'Updated Name',
          kycStatus: 'verified',
        );

        expect(updatedUser.id, user.id);
        expect(updatedUser.email, user.email);
        expect(updatedUser.name, 'Updated Name');
        expect(updatedUser.kycStatus, 'verified');
        expect(updatedUser.roles, user.roles);
      });
    });

    group('Cooperative Model', () {
      test('should create cooperative from JSON', () {
        final json = {
          'id': '1',
          'name': 'Test Cooperative',
          'registration_number': 'COOP-001',
          'address': 'Test Address',
          'phone': '+6281234567890',
          'email': 'coop@test.com',
          'bank_account': '1234567890',
          'profit_sharing_policy': {'investor': 70, 'business': 30},
          'is_active': true,
          'created_at': '2024-01-01T00:00:00Z',
          'updated_at': '2024-01-01T00:00:00Z',
        };

        final cooperative = Cooperative.fromJson(json);

        expect(cooperative.id, '1');
        expect(cooperative.name, 'Test Cooperative');
        expect(cooperative.registrationNumber, 'COOP-001');
        expect(cooperative.address, 'Test Address');
        expect(cooperative.phone, '+6281234567890');
        expect(cooperative.email, 'coop@test.com');
        expect(cooperative.bankAccount, '1234567890');
        expect(cooperative.profitSharingPolicy, {'investor': 70, 'business': 30});
        expect(cooperative.isActive, true);
      });

      test('should convert cooperative to JSON', () {
        final cooperative = Cooperative(
          id: '1',
          name: 'Test Cooperative',
          registrationNumber: 'COOP-001',
          address: 'Test Address',
          phone: '+6281234567890',
          email: 'coop@test.com',
          bankAccount: '1234567890',
          profitSharingPolicy: {'investor': 70, 'business': 30},
          isActive: true,
          createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
          updatedAt: DateTime.parse('2024-01-01T00:00:00Z'),
        );

        final json = cooperative.toJson();

        expect(json['id'], '1');
        expect(json['name'], 'Test Cooperative');
        expect(json['registration_number'], 'COOP-001');
        expect(json['address'], 'Test Address');
        expect(json['phone'], '+6281234567890');
        expect(json['email'], 'coop@test.com');
        expect(json['bank_account'], '1234567890');
        expect(json['profit_sharing_policy'], {'investor': 70, 'business': 30});
        expect(json['is_active'], true);
      });
    });

    group('Business Model', () {
      test('should create business from JSON', () {
        final json = {
          'id': '1',
          'name': 'Test Business',
          'business_type': 'retail',
          'description': 'Test description',
          'owner_id': 'owner-1',
          'cooperative_id': 'coop-1',
          'registration_documents': {'doc1': 'url1'},
          'approval_status': 'approved',
          'is_active': true,
          'created_at': '2024-01-01T00:00:00Z',
          'updated_at': '2024-01-01T00:00:00Z',
        };

        final business = Business.fromJson(json);

        expect(business.id, '1');
        expect(business.name, 'Test Business');
        expect(business.businessType, 'retail');
        expect(business.description, 'Test description');
        expect(business.ownerId, 'owner-1');
        expect(business.cooperativeId, 'coop-1');
        expect(business.registrationDocuments, {'doc1': 'url1'});
        expect(business.approvalStatus, 'approved');
        expect(business.isActive, true);
        expect(business.isApproved, true);
        expect(business.isPending, false);
        expect(business.isRejected, false);
      });

      test('should check business status correctly', () {
        final pendingBusiness = Business(
          id: '1',
          name: 'Test Business',
          businessType: 'retail',
          ownerId: 'owner-1',
          cooperativeId: 'coop-1',
          approvalStatus: 'pending',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(pendingBusiness.isApproved, false);
        expect(pendingBusiness.isPending, true);
        expect(pendingBusiness.isRejected, false);
      });
    });

    group('Project Model', () {
      test('should create project from JSON', () {
        final json = {
          'id': '1',
          'title': 'Test Project',
          'description': 'Test description',
          'business_id': 'business-1',
          'funding_goal': 10000.0,
          'minimum_funding': 1000.0,
          'current_funding': 5000.0,
          'funding_deadline': '2024-12-31T23:59:59Z',
          'profit_sharing_ratio': {'investor': 70, 'business': 30},
          'project_type': 'startup',
          'status': 'active',
          'milestones': [{'title': 'Milestone 1', 'amount': 5000}],
          'documents': {'doc1': 'url1'},
          'created_at': '2024-01-01T00:00:00Z',
          'updated_at': '2024-01-01T00:00:00Z',
        };

        final project = Project.fromJson(json);

        expect(project.id, '1');
        expect(project.title, 'Test Project');
        expect(project.description, 'Test description');
        expect(project.businessId, 'business-1');
        expect(project.fundingGoal, 10000.0);
        expect(project.minimumFunding, 1000.0);
        expect(project.currentFunding, 5000.0);
        expect(project.projectType, 'startup');
        expect(project.status, 'active');
        expect(project.isActive, true);
        expect(project.isDraft, false);
        expect(project.isSubmitted, false);
        expect(project.isApproved, false);
        expect(project.isFunded, false);
        expect(project.isClosed, false);
      });

      test('should calculate funding progress correctly', () {
        final project = Project(
          id: '1',
          title: 'Test Project',
          description: 'Test description',
          businessId: 'business-1',
          fundingGoal: 10000.0,
          currentFunding: 5000.0,
          projectType: 'startup',
          status: 'active',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(project.fundingProgress, 50.0);
        expect(project.isFullyFunded, false);
        expect(project.hasMinimumFunding, true);
      });

      test('should check project status correctly', () {
        final draftProject = Project(
          id: '1',
          title: 'Test Project',
          description: 'Test description',
          businessId: 'business-1',
          fundingGoal: 10000.0,
          currentFunding: 0.0,
          projectType: 'startup',
          status: 'draft',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(draftProject.isDraft, true);
        expect(draftProject.isActive, false);
        expect(draftProject.isFullyFunded, false);
      });

      test('should calculate profit sharing correctly', () {
        final project = Project(
          id: '1',
          title: 'Test Project',
          description: 'Test description',
          businessId: 'business-1',
          fundingGoal: 10000.0,
          currentFunding: 0.0,
          projectType: 'startup',
          status: 'draft',
          profitSharingRatio: {'investor': 70, 'business': 30},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(project.investorSharePercentage, 70.0);
        expect(project.businessSharePercentage, 30.0);
      });
    });

    group('Investment Model', () {
      test('should create investment from JSON', () {
        final json = {
          'id': '1',
          'project_id': 'project-1',
          'investor_id': 'investor-1',
          'amount': 1000.0,
          'investment_date': '2024-01-01T00:00:00Z',
          'profit_sharing_percentage': 70.0,
          'status': 'confirmed',
          'transaction_ref': 'TXN-001',
          'created_at': '2024-01-01T00:00:00Z',
          'updated_at': '2024-01-01T00:00:00Z',
        };

        final investment = Investment.fromJson(json);

        expect(investment.id, '1');
        expect(investment.projectId, 'project-1');
        expect(investment.investorId, 'investor-1');
        expect(investment.amount, 1000.0);
        expect(investment.profitSharingPercentage, 70.0);
        expect(investment.status, 'confirmed');
        expect(investment.transactionRef, 'TXN-001');
        expect(investment.isPending, false);
        expect(investment.isConfirmed, true);
        expect(investment.isRefunded, false);
        expect(investment.isActive, true);
      });

      test('should check investment status correctly', () {
        final pendingInvestment = Investment(
          id: '1',
          projectId: 'project-1',
          investorId: 'investor-1',
          amount: 1000.0,
          profitSharingPercentage: 70.0,
          status: 'pending',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(pendingInvestment.isPending, true);
        expect(pendingInvestment.isConfirmed, false);
        expect(pendingInvestment.isRefunded, false);
        expect(pendingInvestment.isActive, false);
      });
    });

    group('ProfitDistribution Model', () {
      test('should create profit distribution from JSON', () {
        final json = {
          'id': '1',
          'project_id': 'project-1',
          'business_profit': 10000.0,
          'distribution_date': '2024-01-01T00:00:00Z',
          'total_distributed': 7000.0,
          'status': 'distributed',
          'created_at': '2024-01-01T00:00:00Z',
          'updated_at': '2024-01-01T00:00:00Z',
        };

        final distribution = ProfitDistribution.fromJson(json);

        expect(distribution.id, '1');
        expect(distribution.projectId, 'project-1');
        expect(distribution.businessProfit, 10000.0);
        expect(distribution.totalDistributed, 7000.0);
        expect(distribution.status, 'distributed');
        expect(distribution.isCalculated, false);
        expect(distribution.isApproved, false);
        expect(distribution.isDistributed, true);
      });

      test('should check distribution status correctly', () {
        final calculatedDistribution = ProfitDistribution(
          id: '1',
          projectId: 'project-1',
          totalDistributed: 7000.0,
          status: 'calculated',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(calculatedDistribution.isCalculated, true);
        expect(calculatedDistribution.isApproved, false);
        expect(calculatedDistribution.isDistributed, false);
      });
    });
  });

  group('Service Tests', () {
    group('ApiService', () {
      test('should handle API exceptions correctly', () {
        final exception = ApiException(
          statusCode: 400,
          message: 'Bad Request',
        );

        expect(exception.statusCode, 400);
        expect(exception.message, 'Bad Request');
        expect(exception.toString(), 'ApiException: 400 - Bad Request');
      });

      test('should handle error messages correctly', () {
        final apiException = ApiException(statusCode: 500, message: 'Server Error');
        final formatException = FormatException('Invalid JSON');
        final networkException = Exception('Network error');

        expect(ApiService.handleError(apiException), 'Server Error');
        expect(ApiService.handleError(formatException), 'Invalid response format');
        expect(ApiService.handleError(networkException), 'Network error: Exception: Network error');
      });
    });

    group('InvestmentService', () {
      test('should calculate investment returns correctly', () {
        final investment = Investment(
          id: '1',
          projectId: 'project-1',
          investorId: 'investor-1',
          amount: 1000.0,
          profitSharingPercentage: 70.0,
          status: 'confirmed',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final returnAmount = InvestmentService.calculateInvestmentReturn(investment, 10000.0);
        expect(returnAmount, 7000.0);
      });

      test('should calculate total project investment correctly', () {
        final investments = [
          Investment(
            id: '1',
            projectId: 'project-1',
            investorId: 'investor-1',
            amount: 1000.0,
            profitSharingPercentage: 70.0,
            status: 'confirmed',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Investment(
            id: '2',
            projectId: 'project-1',
            investorId: 'investor-2',
            amount: 2000.0,
            profitSharingPercentage: 70.0,
            status: 'confirmed',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Investment(
            id: '3',
            projectId: 'project-1',
            investorId: 'investor-3',
            amount: 500.0,
            profitSharingPercentage: 70.0,
            status: 'pending',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];

        final totalInvestment = InvestmentService.getTotalProjectInvestment(investments);
        expect(totalInvestment, 3000.0); // Only confirmed investments
      });
    });
  });

  group('Feature Coverage Tests', () {
    test('should support multi-role user functionality', () {
      final user = User(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        roles: ['member', 'investor', 'business_owner'],
        kycStatus: 'verified',
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(user.hasRole('member'), true);
      expect(user.hasRole('investor'), true);
      expect(user.hasRole('business_owner'), true);
      expect(user.isMember, true);
      expect(user.isInvestor, true);
      expect(user.isBusinessOwner, true);
    });

    test('should support project lifecycle management', () {
      final project = Project(
        id: '1',
        title: 'Test Project',
        description: 'Test description',
        businessId: 'business-1',
        fundingGoal: 10000.0,
        currentFunding: 0.0,
        projectType: 'startup',
        status: 'draft',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Test status transitions
      expect(project.isDraft, true);
      
      final submittedProject = project.copyWith(status: 'submitted');
      expect(submittedProject.isSubmitted, true);
      
      final approvedProject = submittedProject.copyWith(status: 'approved');
      expect(approvedProject.isApproved, true);
      
      final activeProject = approvedProject.copyWith(status: 'active');
      expect(activeProject.isActive, true);
      
      final fundedProject = activeProject.copyWith(
        status: 'funded',
        currentFunding: 10000.0,
      );
      expect(fundedProject.isFunded, true);
      expect(fundedProject.isFullyFunded, true);
    });

    test('should support profit-sharing calculations', () {
      final project = Project(
        id: '1',
        title: 'Test Project',
        description: 'Test description',
        businessId: 'business-1',
        fundingGoal: 10000.0,
        currentFunding: 0.0,
        projectType: 'startup',
        status: 'active',
        profitSharingRatio: {'investor': 70, 'business': 30},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final investment = Investment(
        id: '1',
        projectId: '1',
        investorId: 'investor-1',
        amount: 1000.0,
        profitSharingPercentage: 70.0,
        status: 'confirmed',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final returnAmount = InvestmentService.calculateInvestmentReturn(investment, 10000.0);
      expect(returnAmount, 7000.0);

      expect(project.investorSharePercentage, 70.0);
      expect(project.businessSharePercentage, 30.0);
    });

    test('should support cooperative oversight features', () {
      final cooperative = Cooperative(
        id: '1',
        name: 'Test Cooperative',
        registrationNumber: 'COOP-001',
        address: 'Test Address',
        phone: '+6281234567890',
        email: 'coop@test.com',
        bankAccount: '1234567890',
        profitSharingPolicy: {'investor': 70, 'business': 30},
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final business = Business(
        id: '1',
        name: 'Test Business',
        businessType: 'retail',
        ownerId: 'owner-1',
        cooperativeId: '1',
        approvalStatus: 'pending',
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(business.cooperativeId, cooperative.id);
      expect(business.isPending, true);
      expect(cooperative.isActive, true);
    });
  });
}
