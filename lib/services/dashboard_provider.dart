import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/patient_model.dart';
import '../models/consultation_model.dart';
import '../models/prescription_model.dart';
import '../models/dashboard_stats.dart';

class DashboardProvider extends ChangeNotifier {
  User? _currentUser;
  List<Patient> _patients = [];
  List<Consultation> _consultations = [];
  DashboardStats? _stats;
  bool _isLoading = false;
  String? _errorMessage;
  List<Patient> _recentActivity = [];

  // ============= GETTERS =============
  User? get currentUser => _currentUser;
  List<Patient> get patients => _patients;
  List<Consultation> get consultations => _consultations;
  DashboardStats? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Patient> get recentActivity => _recentActivity;

  // ============= CHECK IF USER LOGGED IN =============
  Future<bool> isUserLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userName = prefs.getString('userName');
      final userEmail = prefs.getString('userEmail');

      return userName != null && userEmail != null;
    } catch (e) {
      return false;
    }
  }

  // ============= LOAD USER FROM SHARED PREFERENCES =============
  Future<void> loadUserFromPreferences() async {
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userName = prefs.getString('userName') ?? '';
      final userEmail = prefs.getString('userEmail') ?? '';
      final userSpecialization = prefs.getString('userSpecialization') ?? 'General Physician';

      _currentUser = User(
        id: '1',
        name: userName,
        email: userEmail,
        specialization: userSpecialization,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load user: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============= SAVE USER AFTER SIGNUP =============
  Future<void> saveUserData({
    required String name,
    required String email,
    required String specialization,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('userName', name);
      await prefs.setString('userEmail', email);
      await prefs.setString('userSpecialization', specialization);
      await prefs.setBool('isLoggedIn', true);

      _currentUser = User(
        id: '1',
        name: name,
        email: email,
        specialization: specialization,
      );

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to save user data: $e';
      notifyListeners();
    }
  }

  // ============= INITIALIZE DASHBOARD =============
  Future<void> initializeDashboard() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      // Load user from preferences
      await loadUserFromPreferences();

      // Empty lists
      _patients = [];
      _consultations = [];
      _recentActivity = [];

      _stats = DashboardStats(
        totalPatients: 0,
        todayVisits: 0,
        totalConsultations: 0,
        pendingCases: 0,
        completedCases: 0,
        averageConsultationTime: 0.0,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load dashboard: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============= PATIENT OPERATIONS =============
  Future<void> addPatient(Patient patient) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 500));

      _patients.add(patient);
      _updateRecentActivity();
      _updateStats();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to add patient: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePatient(String patientId, Patient updatedPatient) async {
    try {
      final index = _patients.indexWhere((p) => p.id == patientId);
      if (index != -1) {
        _patients[index] = updatedPatient;
        _updateRecentActivity();
        _updateStats();
        notifyListeners();
      } else {
        _errorMessage = 'Patient not found';
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to update patient: $e';
      notifyListeners();
    }
  }

  Future<void> deletePatient(String patientId) async {
    try {
      _patients.removeWhere((p) => p.id == patientId);
      _updateRecentActivity();
      _updateStats();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete patient: $e';
      notifyListeners();
    }
  }

  Patient? getPatientById(String patientId) {
    try {
      return _patients.firstWhere((p) => p.id == patientId);
    } catch (e) {
      return null;
    }
  }

  List<Patient> searchPatients(String query) {
    if (query.isEmpty) return _patients;
    return _patients
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()) ||
        p.disease.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<Patient> getPatientsByStatus(String status) {
    return _patients.where((p) => p.status == status).toList();
  }

  List<Patient> getPatientsByDisease(String disease) {
    return _patients.where((p) => p.disease == disease).toList();
  }

  // ============= CONSULTATION OPERATIONS =============
  Future<void> addConsultation(Consultation consultation) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 500));

      _consultations.add(consultation);
      _updateStats();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to add consultation: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateConsultation(String consultationId, Consultation updatedConsultation) async {
    try {
      final index = _consultations.indexWhere((c) => c.id == consultationId);
      if (index != -1) {
        _consultations[index] = updatedConsultation;
        _updateStats();
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to update consultation: $e';
      notifyListeners();
    }
  }

  Future<void> deleteConsultation(String consultationId) async {
    try {
      _consultations.removeWhere((c) => c.id == consultationId);
      _updateStats();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete consultation: $e';
      notifyListeners();
    }
  }

  List<Consultation> getPatientConsultations(String patientId) {
    return _consultations.where((c) => c.patientId == patientId).toList();
  }

  Consultation? getConsultationById(String consultationId) {
    try {
      return _consultations.firstWhere((c) => c.id == consultationId);
    } catch (e) {
      return null;
    }
  }

  // ============= STATS & ACTIVITY =============
  void _updateRecentActivity() {
    _recentActivity = _patients.take(5).toList();
  }

  void _updateStats() {
    if (_stats == null) return;

    final pending = _patients.where((p) => p.status == 'Pending').length;
    final completed = _patients.where((p) => p.status == 'Completed').length;

    _stats = DashboardStats(
      totalPatients: _patients.length,
      todayVisits: _patients.length,
      totalConsultations: _consultations.length,
      pendingCases: pending,
      completedCases: completed,
      averageConsultationTime: 0.0,
    );
  }

  // ============= LOGOUT - CLEAR DATA =============
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove('userName');
      await prefs.remove('userEmail');
      await prefs.remove('userSpecialization');
      await prefs.setBool('isLoggedIn', false);

      _currentUser = null;
      _patients = [];
      _consultations = [];
      _stats = null;
      _recentActivity = [];
      _errorMessage = null;

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to logout: $e';
      notifyListeners();
    }
  }

  // ============= CLEANUP =============
  void clearData() {
    _currentUser = null;
    _patients = [];
    _consultations = [];
    _stats = null;
    _recentActivity = [];
    _errorMessage = null;
    notifyListeners();
  }
}