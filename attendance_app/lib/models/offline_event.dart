class OfflineEvent {
  final int classId;
  final int? studentId; // if recognized locally
  final String method; // e.g., 'iris'
  final double? confidence;
  final String imagePath;
  final DateTime timestamp;

  OfflineEvent({
    required this.classId,
    this.studentId,
    required this.method,
    this.confidence,
    required this.imagePath,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'classId': classId,
      'studentId': studentId,
      'method': method,
      'confidence': confidence,
      'imagePath': imagePath,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
