class Patient {
  final String id;
  final String name;
  final String disease;
  final String time;
  final String status; // Completed, In Progress, Pending
  final String age;
  final String phoneNumber;
  final String address;
  final String gender;
  final String bloodGroup;
  final DateTime? dateOfBirth;

  Patient({
    required this.id,
    required this.name,
    required this.disease,
    required this.time,
    required this.status,
    required this.age,
    required this.phoneNumber,
    required this.address,
    required this.gender,
    required this.bloodGroup,
    this.dateOfBirth,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      disease: json['disease'] ?? '',
      time: json['time'] ?? '',
      status: json['status'] ?? 'Pending',
      age: json['age'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      gender: json['gender'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'disease': disease,
      'time': time,
      'status': status,
      'age': age,
      'phoneNumber': phoneNumber,
      'address': address,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
    };
  }

  Patient copyWith({
    String? id,
    String? name,
    String? disease,
    String? time,
    String? status,
    String? age,
    String? phoneNumber,
    String? address,
    String? gender,
    String? bloodGroup,
    DateTime? dateOfBirth,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      disease: disease ?? this.disease,
      time: time ?? this.time,
      status: status ?? this.status,
      age: age ?? this.age,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }
}
