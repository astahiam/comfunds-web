import 'package:flutter/material.dart';
import '../models/cooperative.dart';
import '../services/cooperative_service.dart';

class CooperativeProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<Cooperative> _cooperatives = [];
  Cooperative? _selectedCooperative;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Cooperative> get cooperatives => _cooperatives;
  Cooperative? get selectedCooperative => _selectedCooperative;

  Future<void> fetchCooperatives({int page = 1, int limit = 10}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cooperatives = await CooperativeService.getCooperatives(page: page, limit: limit);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCooperative(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedCooperative = await CooperativeService.getCooperative(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createCooperative({
    required String name,
    required String registrationNumber,
    required String address,
    required String phone,
    required String email,
    required String bankAccount,
    Map<String, dynamic>? profitSharingPolicy,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final cooperative = await CooperativeService.createCooperative(
        name: name,
        registrationNumber: registrationNumber,
        address: address,
        phone: phone,
        email: email,
        bankAccount: bankAccount,
        profitSharingPolicy: profitSharingPolicy,
      );
      
      _cooperatives.add(cooperative);
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
}
