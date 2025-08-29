import 'package:flutter/material.dart';
import '../models/project.dart';
import '../services/project_service.dart';

class ProjectProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<Project> _projects = [];
  Project? _selectedProject;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Project> get projects => _projects;
  Project? get selectedProject => _selectedProject;

  Future<void> fetchProjects({String? status, String? cooperativeId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _projects = await ProjectService.getProjects(
        status: status,
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

  Future<void> fetchProject(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedProject = await ProjectService.getProject(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createProject({
    required String title,
    required String description,
    required String businessId,
    required double fundingGoal,
    double? minimumFunding,
    DateTime? fundingDeadline,
    Map<String, dynamic>? profitSharingRatio,
    required String projectType,
    List<Map<String, dynamic>>? milestones,
    Map<String, dynamic>? documents,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final project = await ProjectService.createProject(
        title: title,
        description: description,
        businessId: businessId,
        fundingGoal: fundingGoal,
        minimumFunding: minimumFunding,
        fundingDeadline: fundingDeadline,
        profitSharingRatio: profitSharingRatio,
        projectType: projectType,
        milestones: milestones,
        documents: documents,
      );
      
      _projects.add(project);
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

  Future<bool> submitProject(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedProject = await ProjectService.submitProject(id);
      final index = _projects.indexWhere((p) => p.id == id);
      if (index != -1) {
        _projects[index] = updatedProject;
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
