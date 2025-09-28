import 'package:hive/hive.dart';

part 'offline_event.g.dart';

@HiveType(typeId: 0) // Add this annotation to your class
class OfflineEvent {
  @HiveField(0) // Add this annotation to each field
  final int classId;
  
  @HiveField(1)
  final int? studentId; // if recognized locally
  
  @HiveField(2)
  final String method; // e.g., 'iris'
  
  @HiveField(3)
  final double? confidence;
  
  @HiveField(4)
  final String imagePath;
  
  @HiveField(5)
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