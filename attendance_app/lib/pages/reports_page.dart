import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/attendance_record.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<AttendanceRecord> box = Hive.box<AttendanceRecord>('attendance_records');

    return Scaffold(
      appBar: AppBar(title: const Text("Attendance Reports")),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<AttendanceRecord> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("No attendance records found."));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final record = box.getAt(index)!;
              return Card(
                margin: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ExpansionTile(
                  title: Text("Date: ${record.date}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("Roll No")),
                          DataColumn(label: Text("Name")),
                          DataColumn(label: Text("Status")),
                        ],
                        rows: record.records.map(
                          (student) => DataRow(cells: [
                            DataCell(Text(student.rollNumber)),
                            DataCell(Text(student.studentName)),
                            DataCell(Text(
                              student.isPresent ? "Present ✅" : "Absent ❌",
                              style: TextStyle(color: student.isPresent ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                            )),
                          ]),
                        ).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
