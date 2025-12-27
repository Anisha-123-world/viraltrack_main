import 'package:flutter/cupertino.dart';

import '../models/consultation_model.dart';
import '../models/prescription_model.dart';

class ConsultationProvider extends ChangeNotifier {
  List<Consultation> _consultations = [];
  List<Prescription> _currentPrescriptions = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Consultation> get consultations => _consultations;
  List<Prescription> get currentPrescriptions => _currentPrescriptions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> saveConsultation({
    required String patientId,
    required String patientName,
    required String symptoms,
    required String diagnosis,
    required List<Prescription> prescriptions,
    String notes = '',
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 500));

      final consultation = Consultation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        patientId: patientId,
        patientName: patientName,
        symptoms: symptoms,
        diagnosis: diagnosis,
        prescriptions: prescriptions,
        notes: notes,
        consultationDate: DateTime.now(),
        status: 'Completed',
        doctorName: 'Dr. John Doe',
      );

      _consultations.add(consultation);
      _currentPrescriptions = [];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to save consultation: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void addPrescription(Prescription prescription) {
    _currentPrescriptions.add(prescription);
    notifyListeners();
  }

  void removePrescription(int index) {
    if (index >= 0 && index < _currentPrescriptions.length) {
      _currentPrescriptions.removeAt(index);
      notifyListeners();
    }
  }

  void clearPrescriptions() {
    _currentPrescriptions = [];
    notifyListeners();
  }

  List<Consultation> getPatientConsultations(String patientId) {
    return _consultations.where((c) => c.patientId == patientId).toList();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
