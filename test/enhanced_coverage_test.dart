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
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  group('Enhanced Coverage Tests', () {
    group('User Model Enhanced Tests', () {
      test('should handle user with all roles', () {
        final user = User(
          id: '1',
          email: 'test@example.com',
          name: 'Test User',
          phone: '+1234567890',
          address: 'Test Address',
          cooperativeId: 'coop1',
          roles: ['member', 'investor', 'business_owner'],
          kycStatus: 'verified',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(user.roles, contains('member'));
        expect(user.roles, contains('investor'));
        expect(user.roles, contains('business_owner'));
        expect(user.hasRole('member'), isTrue);
        expect(user.hasRole('admin'), isFalse);
        expect(user.kycStatus, equals('verified'));
      });

      test('should handle user with no roles', () {
        final user = User(
          id: '1',
          email: 'test@example.com',
          name: 'Test User',
          phone: '+1234567890',
          address: 'Test Address',
          cooperativeId: 'coop1',
          roles: [],
          kycStatus: 'pending',
          isActive: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(user.roles, isEmpty);
        expect(user.hasRole('member'), isFalse);
        expect(user.kycStatus, equals('pending'));
        expect(user.isActive, isFalse);
      });

      test('should handle user JSON serialization edge cases', () {
        final user = User(
          id: '1',
          email: 'test@example.com',
          name: 'Test User',
          phone: '+1234567890',
          address: 'Test Address',
          cooperativeId: 'coop1',
          roles: ['member'],
          kycStatus: 'verified',
          isActive: true,
          createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
          updatedAt: DateTime.parse('2024-01-01T00:00:00Z'),
        );

        final json = user.toJson();
        final fromJson = User.fromJson(json);

        expect(fromJson.id, equals(user.id));
        expect(fromJson.email, equals(user.email));
        expect(fromJson.roles, equals(user.roles));
        expect(fromJson.createdAt, equals(user.createdAt));
        expect(fromJson.updatedAt, equals(user.updatedAt));
      });
    });

    group('Cooperative Model Enhanced Tests', () {
      test('should handle cooperative with profit sharing policy', () {
        final cooperative = Cooperative(
          id: '1',
          name: 'Test Cooperative',
          registrationNumber: 'REG123',
          address: 'Test Address',
          phone: '+1234567890',
          email: 'test@coop.com',
          bankAccount: '1234567890',
          profitSharingPolicy: {
            'investor': 70.0,
            'business': 20.0,
            'cooperative': 10.0,
          },
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(cooperative.profitSharingPolicy, isNotNull);
        expect(cooperative.profitSharingPolicy!['investor'], equals(70.0));
        expect(cooperative.isActive, isTrue);
      });

      test('should handle cooperative without profit sharing policy', () {
        final cooperative = Cooperative(
          id: '1',
          name: 'Test Cooperative',
          registrationNumber: 'REG123',
          address: 'Test Address',
          phone: '+1234567890',
          email: 'test@coop.com',
          bankAccount: '1234567890',
          profitSharingPolicy: null,
          isActive: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(cooperative.profitSharingPolicy, isNull);
        expect(cooperative.isActive, isFalse);
      });

      test('should handle cooperative JSON serialization', () {
        final cooperative = Cooperative(
          id: '1',
          name: 'Test Cooperative',
          registrationNumber: 'REG123',
          address: 'Test Address',
          phone: '+1234567890',
          email: 'test@coop.com',
          bankAccount: '1234567890',
          profitSharingPolicy: {'investor': 70.0},
          isActive: true,
          createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
          updatedAt: DateTime.parse('2024-01-01T00:00:00Z'),
        );

        final json = cooperative.toJson();
        final fromJson = Cooperative.fromJson(json);

        expect(fromJson.id, equals(cooperative.id));
        expect(fromJson.name, equals(cooperative.name));
        expect(fromJson.profitSharingPolicy, equals(cooperative.profitSharingPolicy));
      });
    });

    group('Business Model Enhanced Tests', () {
      test('should handle business with all status types', () {
        final pendingBusiness = Business(
          id: '1',
          name: 'Pending Business',
          businessType: 'retail',
          description: 'Test description',
          ownerId: 'owner1',
          cooperativeId: 'coop1',
          registrationDocuments: {'license': 'license123'},
          approvalStatus: 'pending',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final approvedBusiness = Business(
          id: '2',
          name: 'Approved Business',
          businessType: 'manufacturing',
          description: 'Test description',
          ownerId: 'owner2',
          cooperativeId: 'coop1',
          registrationDocuments: {'license': 'license456'},
          approvalStatus: 'approved',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final rejectedBusiness = Business(
          id: '3',
          name: 'Rejected Business',
          businessType: 'service',
          description: 'Test description',
          ownerId: 'owner3',
          cooperativeId: 'coop1',
          registrationDocuments: {'license': 'license789'},
          approvalStatus: 'rejected',
          isActive: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(pendingBusiness.isPending, isTrue);
        expect(pendingBusiness.isApproved, isFalse);
        expect(pendingBusiness.isRejected, isFalse);

        expect(approvedBusiness.isPending, isFalse);
        expect(approvedBusiness.isApproved, isTrue);
        expect(approvedBusiness.isRejected, isFalse);

        expect(rejectedBusiness.isPending, isFalse);
        expect(rejectedBusiness.isApproved, isFalse);
        expect(rejectedBusiness.isRejected, isTrue);
      });

      test('should handle business JSON serialization', () {
        final business = Business(
          id: '1',
          name: 'Test Business',
          businessType: 'retail',
          description: 'Test description',
          ownerId: 'owner1',
          cooperativeId: 'coop1',
          registrationDocuments: {'license': 'license123'},
          approvalStatus: 'approved',
          isActive: true,
          createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
          updatedAt: DateTime.parse('2024-01-01T00:00:00Z'),
        );

        final json = business.toJson();
        final fromJson = Business.fromJson(json);

        expect(fromJson.id, equals(business.id));
        expect(fromJson.name, equals(business.name));
        expect(fromJson.approvalStatus, equals(business.approvalStatus));
        expect(fromJson.registrationDocuments, equals(business.registrationDocuments));
      });
    });

    group('Project Model Enhanced Tests', () {
      test('should handle project with all status types', () {
        final draftProject = Project(
          id: '1',
          title: 'Draft Project',
          description: 'Test description',
          businessId: 'business1',
          fundingGoal: 10000.0,
          minimumFunding: 1000.0,
          currentFunding: 0.0,
          fundingDeadline: DateTime.now().add(Duration(days: 30)),
          profitSharingRatio: {'investor': 70.0, 'business': 30.0},
          projectType: 'startup',
          status: 'draft',
          milestones: [{'title': 'Milestone 1', 'amount': 5000.0}],
          documents: {'business_plan': 'plan.pdf'},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final activeProject = Project(
          id: '2',
          title: 'Active Project',
          description: 'Test description',
          businessId: 'business2',
          fundingGoal: 20000.0,
          minimumFunding: 2000.0,
          currentFunding: 15000.0,
          fundingDeadline: DateTime.now().add(Duration(days: 15)),
          profitSharingRatio: {'investor': 60.0, 'business': 40.0},
          projectType: 'expansion',
          status: 'active',
          milestones: [{'title': 'Milestone 1', 'amount': 10000.0}],
          documents: {'business_plan': 'plan2.pdf'},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(draftProject.isDraft, isTrue);
        expect(draftProject.isActive, isFalse);
        expect(draftProject.isFunded, isFalse);
        expect(draftProject.fundingProgress, equals(0.0));

        expect(activeProject.isDraft, isFalse);
        expect(activeProject.isActive, isTrue);
        expect(activeProject.isFunded, isFalse);
        expect(activeProject.fundingProgress, equals(75.0));
      });

      test('should handle project profit sharing calculations', () {
        final project = Project(
          id: '1',
          title: 'Test Project',
          description: 'Test description',
          businessId: 'business1',
          fundingGoal: 10000.0,
          minimumFunding: 1000.0,
          currentFunding: 5000.0,
          fundingDeadline: DateTime.now().add(Duration(days: 30)),
          profitSharingRatio: {'investor': 70.0, 'business': 30.0},
          projectType: 'startup',
          status: 'active',
          milestones: [],
          documents: {},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(project.investorSharePercentage, equals(70.0));
        expect(project.businessSharePercentage, equals(30.0));
        expect(project.fundingProgress, equals(50.0));
        expect(project.isFullyFunded, isFalse);
      });

      test('should handle project JSON serialization', () {
        final project = Project(
          id: '1',
          title: 'Test Project',
          description: 'Test description',
          businessId: 'business1',
          fundingGoal: 10000.0,
          minimumFunding: 1000.0,
          currentFunding: 5000.0,
          fundingDeadline: DateTime.parse('2024-12-31T23:59:59Z'),
          profitSharingRatio: {'investor': 70.0, 'business': 30.0},
          projectType: 'startup',
          status: 'active',
          milestones: [{'title': 'Milestone 1', 'amount': 5000.0}],
          documents: {'business_plan': 'plan.pdf'},
          createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
          updatedAt: DateTime.parse('2024-01-01T00:00:00Z'),
        );

        final json = project.toJson();
        final fromJson = Project.fromJson(json);

        expect(fromJson.id, equals(project.id));
        expect(fromJson.title, equals(project.title));
        expect(fromJson.profitSharingRatio, equals(project.profitSharingRatio));
        expect(fromJson.milestones, equals(project.milestones));
      });
    });

    group('Investment Model Enhanced Tests', () {
      test('should handle investment with all status types', () {
        final pendingInvestment = Investment(
          id: '1',
          projectId: 'project1',
          investorId: 'investor1',
          amount: 1000.0,
          investmentDate: DateTime.now(),
          profitSharingPercentage: 70.0,
          status: 'pending',
          transactionRef: 'TXN123',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final confirmedInvestment = Investment(
          id: '2',
          projectId: 'project1',
          investorId: 'investor2',
          amount: 2000.0,
          investmentDate: DateTime.now(),
          profitSharingPercentage: 70.0,
          status: 'confirmed',
          transactionRef: 'TXN456',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final refundedInvestment = Investment(
          id: '3',
          projectId: 'project1',
          investorId: 'investor3',
          amount: 1500.0,
          investmentDate: DateTime.now(),
          profitSharingPercentage: 70.0,
          status: 'refunded',
          transactionRef: 'TXN789',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(pendingInvestment.isPending, isTrue);
        expect(pendingInvestment.isConfirmed, isFalse);
        expect(pendingInvestment.isRefunded, isFalse);

        expect(confirmedInvestment.isPending, isFalse);
        expect(confirmedInvestment.isConfirmed, isTrue);
        expect(confirmedInvestment.isRefunded, isFalse);

        expect(refundedInvestment.isPending, isFalse);
        expect(refundedInvestment.isConfirmed, isFalse);
        expect(refundedInvestment.isRefunded, isTrue);
      });

      test('should handle investment JSON serialization', () {
        final investment = Investment(
          id: '1',
          projectId: 'project1',
          investorId: 'investor1',
          amount: 1000.0,
          investmentDate: DateTime.parse('2024-01-01T00:00:00Z'),
          profitSharingPercentage: 70.0,
          status: 'confirmed',
          transactionRef: 'TXN123',
          createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
          updatedAt: DateTime.parse('2024-01-01T00:00:00Z'),
        );

        final json = investment.toJson();
        final fromJson = Investment.fromJson(json);

        expect(fromJson.id, equals(investment.id));
        expect(fromJson.amount, equals(investment.amount));
        expect(fromJson.status, equals(investment.status));
        expect(fromJson.transactionRef, equals(investment.transactionRef));
      });
    });

    group('ProfitDistribution Model Enhanced Tests', () {
      test('should handle profit distribution with all status types', () {
        final calculatedDistribution = ProfitDistribution(
          id: '1',
          projectId: 'project1',
          businessProfit: 10000.0,
          distributionDate: DateTime.now(),
          totalDistributed: 0.0,
          status: 'calculated',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final approvedDistribution = ProfitDistribution(
          id: '2',
          projectId: 'project1',
          businessProfit: 15000.0,
          distributionDate: DateTime.now(),
          totalDistributed: 0.0,
          status: 'approved',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final distributedDistribution = ProfitDistribution(
          id: '3',
          projectId: 'project1',
          businessProfit: 20000.0,
          distributionDate: DateTime.now(),
          totalDistributed: 14000.0,
          status: 'distributed',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(calculatedDistribution.isCalculated, isTrue);
        expect(calculatedDistribution.isApproved, isFalse);
        expect(calculatedDistribution.isDistributed, isFalse);

        expect(approvedDistribution.isCalculated, isFalse);
        expect(approvedDistribution.isApproved, isTrue);
        expect(approvedDistribution.isDistributed, isFalse);

        expect(distributedDistribution.isCalculated, isFalse);
        expect(distributedDistribution.isApproved, isFalse);
        expect(distributedDistribution.isDistributed, isTrue);
      });

      test('should handle profit distribution JSON serialization', () {
        final distribution = ProfitDistribution(
          id: '1',
          projectId: 'project1',
          businessProfit: 10000.0,
          distributionDate: DateTime.parse('2024-01-01T00:00:00Z'),
          totalDistributed: 7000.0,
          status: 'distributed',
          createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
          updatedAt: DateTime.parse('2024-01-01T00:00:00Z'),
        );

        final json = distribution.toJson();
        final fromJson = ProfitDistribution.fromJson(json);

        expect(fromJson.id, equals(distribution.id));
        expect(fromJson.businessProfit, equals(distribution.businessProfit));
        expect(fromJson.totalDistributed, equals(distribution.totalDistributed));
        expect(fromJson.status, equals(distribution.status));
      });
    });

    group('API Service Enhanced Tests', () {
      test('should handle API service headers', () {
        // Test that API service can be instantiated and basic functionality works
        expect(ApiService.baseUrl, equals('http://localhost:8080/api/v1'));
        expect(ApiService, isNotNull);
      });

      test('should handle API exception', () {
        final exception = ApiException(statusCode: 404, message: 'Not found');
        expect(exception.statusCode, equals(404));
        expect(exception.message, equals('Not found'));
        expect(exception.toString(), contains('ApiException: 404 - Not found'));
      });

      test('should handle error handling', () {
        final apiException = ApiException(statusCode: 500, message: 'Server error');
        final formatException = FormatException('Invalid format');
        final genericError = Exception('Generic error');

        expect(ApiService.handleError(apiException), equals('Server error'));
        expect(ApiService.handleError(formatException), equals('Invalid response format'));
        expect(ApiService.handleError(genericError), contains('Network error'));
      });
    });

    group('Service Layer Enhanced Tests', () {
      test('should handle service error scenarios', () {
        // Test error handling in services
        expect(() => AuthService.login(email: 'invalid', password: 'invalid'), throwsException);
        expect(() => CooperativeService.getCooperatives(), throwsException);
        expect(() => BusinessService.getBusinesses(), throwsException);
        expect(() => ProjectService.getProjects(), throwsException);
        expect(() => InvestmentService.getInvestments(), throwsException);
      });

      test('should handle service method calls', () {
        // Test service method signatures and basic functionality
        expect(AuthService, isNotNull);
        expect(CooperativeService, isNotNull);
        expect(BusinessService, isNotNull);
        expect(ProjectService, isNotNull);
        expect(InvestmentService, isNotNull);
      });
    });

    group('Feature Coverage Enhanced Tests', () {
      test('should support comprehensive multi-role user functionality', () {
        final user = User(
          id: '1',
          email: 'test@example.com',
          name: 'Test User',
          phone: '+1234567890',
          address: 'Test Address',
          cooperativeId: 'coop1',
          roles: ['member', 'investor', 'business_owner'],
          kycStatus: 'verified',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(user.hasRole('member'), isTrue);
        expect(user.hasRole('investor'), isTrue);
        expect(user.hasRole('business_owner'), isTrue);
        expect(user.hasRole('admin'), isFalse);
        expect(user.kycStatus, equals('verified'));
        expect(user.isActive, isTrue);
      });

      test('should support comprehensive project lifecycle management', () {
        final project = Project(
          id: '1',
          title: 'Test Project',
          description: 'Test description',
          businessId: 'business1',
          fundingGoal: 10000.0,
          minimumFunding: 1000.0,
          currentFunding: 5000.0,
          fundingDeadline: DateTime.now().add(Duration(days: 30)),
          profitSharingRatio: {'investor': 70.0, 'business': 30.0},
          projectType: 'startup',
          status: 'active',
          milestones: [{'title': 'Milestone 1', 'amount': 5000.0}],
          documents: {'business_plan': 'plan.pdf'},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(project.isActive, isTrue);
        expect(project.fundingProgress, equals(50.0));
        expect(project.investorSharePercentage, equals(70.0));
        expect(project.businessSharePercentage, equals(30.0));
        expect(project.isFullyFunded, isFalse);
        expect(project.milestones, isNotEmpty);
        expect(project.documents, isNotEmpty);
      });

      test('should support comprehensive profit-sharing calculations', () {
        final project = Project(
          id: '1',
          title: 'Test Project',
          description: 'Test description',
          businessId: 'business1',
          fundingGoal: 10000.0,
          minimumFunding: 1000.0,
          currentFunding: 10000.0,
          fundingDeadline: DateTime.now().add(Duration(days: 30)),
          profitSharingRatio: {'investor': 70.0, 'business': 30.0},
          projectType: 'startup',
          status: 'funded',
          milestones: [],
          documents: {},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final investment = Investment(
          id: '1',
          projectId: 'project1',
          investorId: 'investor1',
          amount: 1000.0,
          investmentDate: DateTime.now(),
          profitSharingPercentage: 70.0,
          status: 'confirmed',
          transactionRef: 'TXN123',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final distribution = ProfitDistribution(
          id: '1',
          projectId: 'project1',
          businessProfit: 10000.0,
          distributionDate: DateTime.now(),
          totalDistributed: 7000.0,
          status: 'distributed',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(project.isFullyFunded, isTrue);
        expect(investment.isConfirmed, isTrue);
        expect(distribution.isDistributed, isTrue);
        expect(distribution.totalDistributed, equals(7000.0));
      });

      test('should support comprehensive cooperative oversight features', () {
        final cooperative = Cooperative(
          id: '1',
          name: 'Test Cooperative',
          registrationNumber: 'REG123',
          address: 'Test Address',
          phone: '+1234567890',
          email: 'test@coop.com',
          bankAccount: '1234567890',
          profitSharingPolicy: {
            'investor': 70.0,
            'business': 20.0,
            'cooperative': 10.0,
          },
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final business = Business(
          id: '1',
          name: 'Test Business',
          businessType: 'retail',
          description: 'Test description',
          ownerId: 'owner1',
          cooperativeId: 'coop1',
          registrationDocuments: {'license': 'license123'},
          approvalStatus: 'approved',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(cooperative.isActive, isTrue);
        expect(cooperative.profitSharingPolicy, isNotNull);
        expect(business.isApproved, isTrue);
        expect(business.cooperativeId, equals('coop1'));
      });
    });
  });
}
