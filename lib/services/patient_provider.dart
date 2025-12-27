import 'package:flutter/cupertino.dart';

import '../models/patient_model.dart';

class PatientProvider extends ChangeNotifier {
  List<Patient> _allPatients = [];
  bool _isLoading = false;
  String? _errorMessage;
  List<String> _filterOptions = ['All', 'Diabetes', 'Hypertension', 'Asthma', 'Heart Disease'];

  List<Patient> get allPatients => _allPatients;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<String> get filterOptions => _filterOptions;

  Future<void> loadPatients() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // Completely empty list
      _allPatients = [];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load patients: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPatient(Patient patient) async {
    try {
      _allPatients.add(patient);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to add patient: $e';
      notifyListeners();
    }
  }

  List<Patient> filterPatients(String filter, String searchQuery) {
    List<Patient> filtered = _allPatients;

    if (filter != 'All') {
      filtered = filtered.where((p) => p.disease == filter || p.status == filter).toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    filtered.sort((a, b) => a.name.compareTo(b.name));
    return filtered;
  }

  Future<void> deletePatient(String patientId) async {
    try {
      _allPatients.removeWhere((p) => p.id == patientId);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete patient: $e';
      notifyListeners();
    }
  }

  Future<void> updatePatient(String patientId, Patient updatedPatient) async {
    try {
      final index = _allPatients.indexWhere((p) => p.id == patientId);
      if (index != -1) {
        _allPatients[index] = updatedPatient;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to update patient: $e';
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

