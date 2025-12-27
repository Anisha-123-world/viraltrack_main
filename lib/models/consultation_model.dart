import 'package:viraltrack/models/prescription_model.dart';

class Consultation {
  final String id;
  final String patientId;
  final String patientName;
  final String symptoms;
  final String diagnosis;
  final List<Prescription> prescriptions;
  final String notes;
  final DateTime consultationDate;
  final String status; // Pending, Completed, Cancelled
  final String? followUpDate;
  final String? doctorName;

  Consultation({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.symptoms,
    required this.diagnosis,
    required this.prescriptions,
    required this.notes,
    required this.consultationDate,
    required this.status,
    this.followUpDate,
    this.doctorName,
  });

  factory Consultation.fromJson(Map<String, dynamic> json) {
    List<Prescription> pres = [];
    if (json['prescriptions'] != null) {
      pres = List<Prescription>.from(
        json['prescriptions'].map((x) => Prescription.fromJson(x)),
      );
    }

    return Consultation(
      id: json['id'] ?? '',
      patientId: json['patientId'] ?? '',
      patientName: json['patientName'] ?? '',
      symptoms: json['symptoms'] ?? '',
      diagnosis: json['diagnosis'] ?? '',
      prescriptions: pres,
      notes: json['notes'] ?? '',
      consultationDate: DateTime.parse(json['consultationDate'] ?? DateTime.now().toString()),
      status: json['status'] ?? 'Pending',
      followUpDate: json['followUpDate'],
      doctorName: json['doctorName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'symptoms': symptoms,
      'diagnosis': diagnosis,
      'prescriptions': prescriptions.map((x) => x.toJson()).toList(),
      'notes': notes,
      'consultationDate': consultationDate.toIso8601String(),
      'status': status,
      'followUpDate': followUpDate,
      'doctorName': doctorName,
    };
  }

  Consultation copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? symptoms,
    String? diagnosis,
    List<Prescription>? prescriptions,
    String? notes,
    DateTime? consultationDate,
    String? status,
    String? followUpDate,
    String? doctorName,
  }) {
    return Consultation(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      symptoms: symptoms ?? this.symptoms,
      diagnosis: diagnosis ?? this.diagnosis,
      prescriptions: prescriptions ?? this.prescriptions,
      notes: notes ?? this.notes,
      consultationDate: consultationDate ?? this.consultationDate,
      status: status ?? this.status,
      followUpDate: followUpDate ?? this.followUpDate,
      doctorName: doctorName ?? this.doctorName,
    );
  }
}
