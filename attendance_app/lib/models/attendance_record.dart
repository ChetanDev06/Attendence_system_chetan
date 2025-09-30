import 'package:hive/hive.dart';

part 'attendance_record.g.dart';

@HiveType(typeId: 1)
class AttendanceRecord {
  @HiveField(0)
  final String date; // e.g. "2025-09-30"

  @HiveField(1)
  final List<StudentAttendance> records;

  AttendanceRecord({required this.date, required this.records});
}

@HiveType(typeId: 2)
class StudentAttendance {
  @HiveField(0)
  final String studentName;

  @HiveField(1)
  final String rollNumber;

  @HiveField(2)
  final bool isPresent;

  StudentAttendance({
    required this.studentName,
    required this.rollNumber,
    required this.isPresent,
  });
}
