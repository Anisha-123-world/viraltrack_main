class DashboardStats {
  final int totalPatients;
  final int todayVisits;
  final int totalConsultations;
  final int pendingCases;
  final int completedCases;
  final double averageConsultationTime;

  DashboardStats({
    required this.totalPatients,
    required this.todayVisits,
    required this.totalConsultations,
    required this.pendingCases,
    this.completedCases = 0,
    this.averageConsultationTime = 0.0,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalPatients: json['totalPatients'] ?? 0,
      todayVisits: json['todayVisits'] ?? 0,
      totalConsultations: json['totalConsultations'] ?? 0,
      pendingCases: json['pendingCases'] ?? 0,
      completedCases: json['completedCases'] ?? 0,
      averageConsultationTime: (json['averageConsultationTime'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPatients': totalPatients,
      'todayVisits': todayVisits,
      'totalConsultations': totalConsultations,
      'pendingCases': pendingCases,
      'completedCases': completedCases,
      'averageConsultationTime': averageConsultationTime,
    };
  }
}
