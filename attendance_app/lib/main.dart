import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/offline_event.dart' as models;
import 'models/attendance_record.dart';
import 'services/db_helper.dart';
import 'pages/home_page.dart';
import 'pages/register_page.dart';
import 'pages/attendance_page.dart';
import 'pages/reports_page.dart';
import 'pages/settings_page.dart';
import 'pages/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<CameraDescription> cameras = [];
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize SQLite DB
  await DBHelper.initDb();

  // Initialize Hive
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(models.OfflineEventAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(AttendanceRecordAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(StudentAttendanceAdapter());
  }
  await Hive.openBox<models.OfflineEvent>('offline_events');
  await Hive.openBox<AttendanceRecord>('attendance_records');

  // Setup available cameras
  try {
    cameras = await availableCameras();
  } catch (e) {
    debugPrint("⚠️ Camera not available: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Attendance App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            fontFamily: 'Roboto',
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            fontFamily: 'Roboto',
          ),
          themeMode: currentMode,
          home: const HomePage(),
          routes: {
            '/register': (context) => const RegisterPage(),
            '/attendance': (context) => const AttendancePage(),
            '/reports': (context) => const ReportsPage(),
            '/settings': (context) => const SettingsPage(),
            '/profile': (context) => const ProfilePage(),
          },
        );
      },
    );
  }
}
