class Prescription {
  final String medicine;
  final String dosage;
  final String duration;

  Prescription({
    required this.medicine,
    required this.dosage,
    required this.duration,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      medicine: json['medicine'] ?? '',
      dosage: json['dosage'] ?? '',
      duration: json['duration'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicine': medicine,
      'dosage': dosage,
      'duration': duration,
    };
  }

  Prescription copyWith({
    String? medicine,
    String? dosage,
    String? duration,
  }) {
    return Prescription(
      medicine: medicine ?? this.medicine,
      dosage: dosage ?? this.dosage,
      duration: duration ?? this.duration,
    );
  }
}

