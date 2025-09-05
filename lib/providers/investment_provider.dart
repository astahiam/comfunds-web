import 'package:flutter/material.dart';
import '../models/investment.dart';
import '../services/investment_service.dart';

class InvestmentProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<Investment> _investments = [];
  List<Investment> _portfolio = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Investment> get investments => _investments;
  List<Investment> get portfolio => _portfolio;

  Future<void> fetchInvestments({String? status}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _investments = await InvestmentService.getInvestments(status: status);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPortfolio(String investorId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _portfolio = await InvestmentService.getInvestorPortfolio(investorId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createInvestment({
    required String projectId,
    required String investorId,
    required double amount,
    double? profitSharingPercentage,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final investment = await InvestmentService.createInvestment(
        projectId: projectId,
        investorId: investorId,
        amount: amount,
        profitSharingPercentage: profitSharingPercentage,
      );
      
      _investments.add(investment);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> confirmInvestment(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedInvestment = await InvestmentService.confirmInvestment(id);
      final index = _investments.indexWhere((inv) => inv.id == id);
      if (index != -1) {
        _investments[index] = updatedInvestment;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Investment methods for cooperative members
  Future<void> fetchInvestmentsByMember(String memberId, {String? cooperativeId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _investments = await InvestmentService.getInvestmentsByMember(
        memberId,
        cooperativeId: cooperativeId,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<dynamic>> getAvailableProjectsForInvestment({String? cooperativeId}) async {
    try {
      return await InvestmentService.getAvailableProjectsForInvestment(
        cooperativeId: cooperativeId,
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  Future<bool> canInvestInProject(String userId, String projectId) async {
    try {
      return await InvestmentService.canInvestInProject(userId, projectId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>> getInvestmentLimits(String userId) async {
    try {
      return await InvestmentService.getInvestmentLimits(userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return {};
    }
  }

  Future<bool> withdrawInvestment(String id, {String? reason}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedInvestment = await InvestmentService.withdrawInvestment(id, reason: reason);
      final index = _investments.indexWhere((inv) => inv.id == id);
      if (index != -1) {
        _investments[index] = updatedInvestment;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchInvestmentHistory(String userId, {String? status}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _investments = await InvestmentService.getInvestmentHistory(userId, status: status);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Investment>> getProjectInvestments(String projectId) async {
    try {
      return await InvestmentService.getProjectInvestments(projectId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }
}
