import 'package:flutter/material.dart';
import '../models/business.dart';
import '../services/business_service.dart';

class BusinessProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<Business> _businesses = [];
  Business? _selectedBusiness;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Business> get businesses => _businesses;
  Business? get selectedBusiness => _selectedBusiness;

  Future<void> fetchBusinesses({String? status}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _businesses = await BusinessService.getBusinesses(status: status);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBusiness(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedBusiness = await BusinessService.getBusiness(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBusinessesByOwner(String ownerId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _businesses = await BusinessService.getBusinessesByOwner(ownerId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createBusiness({
    required String name,
    required String businessType,
    String? description,
    required String ownerId,
    required String cooperativeId,
    Map<String, dynamic>? registrationDocuments,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final business = await BusinessService.createBusiness(
        name: name,
        businessType: businessType,
        description: description,
        ownerId: ownerId,
        cooperativeId: cooperativeId,
        registrationDocuments: registrationDocuments,
      );
      
      _businesses.add(business);
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

  Future<bool> updateBusiness({
    required String id,
    String? name,
    String? businessType,
    String? description,
    Map<String, dynamic>? registrationDocuments,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedBusiness = await BusinessService.updateBusiness(
        id: id,
        name: name,
        businessType: businessType,
        description: description,
        registrationDocuments: registrationDocuments,
      );
      
      final index = _businesses.indexWhere((b) => b.id == id);
      if (index != -1) {
        _businesses[index] = updatedBusiness;
      }
      
      if (_selectedBusiness?.id == id) {
        _selectedBusiness = updatedBusiness;
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

  Future<bool> approveBusiness(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedBusiness = await BusinessService.approveBusiness(id);
      final index = _businesses.indexWhere((b) => b.id == id);
      if (index != -1) {
        _businesses[index] = updatedBusiness;
      }
      
      if (_selectedBusiness?.id == id) {
        _selectedBusiness = updatedBusiness;
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
}
