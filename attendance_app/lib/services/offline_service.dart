import 'package:hive/hive.dart';

part 'offline_service.g.dart'; // ← must match this file exactly

@HiveType(typeId: 0)
class OfflineEvent extends HiveObject {
  @HiveField(0)
  final int classId;

  @HiveField(1)
  final int? studentId;

  @HiveField(2)
  final String method;

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

  Map<String, dynamic> toJson() => {
        'classId': classId,
        'studentId': studentId,
        'method': method,
        'confidence': confidence,
        'imagePath': imagePath,
        'timestamp': timestamp.toIso8601String(),
      };
}
