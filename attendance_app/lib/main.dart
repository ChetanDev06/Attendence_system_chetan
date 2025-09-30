import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:attendance_app/models/offline_event.dart' as models;
import 'package:http/http.dart' as http;
import 'dart:convert';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(models.OfflineEventAdapter());
  await Hive.openBox<models.OfflineEvent>('offline_events');

  // Get available cameras
  cameras = await availableCameras();

  runApp(const MyApp());
}

// ------------------- Other pages -------------------
// ✅ Register Page with Iris Capture
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollController = TextEditingController();

  CameraController? _cameraController;
  bool _isCameraReady = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      try {
        await _cameraController!.initialize();
        if (!mounted) return;
        setState(() {
          _isCameraReady = true;
        });
      } catch (e) {
        print("Camera init error: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error initializing camera: $e")),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No cameras available")),
        );
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _nameController.dispose();
    _rollController.dispose();
    super.dispose();
  }

  Future<void> _captureIris() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    try {
      final XFile image = await _cameraController!.takePicture();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Iris captured: ${image.path}")),
      );
      // Save or send this image to your ML/Backend service
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to capture iris: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Student")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Student Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Student Name",
                  hintText: "Enter full name",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter the student's name" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _rollController,
                decoration: InputDecoration(
                  labelText: "Roll Number",
                  hintText: "e.g., 101, 2024CS01",
                  prefixIcon: const Icon(Icons.numbers),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter the roll number" : null,
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        "Iris Biometric Capture",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _isCameraReady
                          ? SizedBox(
                              height: 200,
                              child: CameraPreview(_cameraController!),
                            )
                          : const Icon(Icons.visibility_outlined,
                              size: 60, color: Colors.deepPurple),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("Capture Iris"),
                        onPressed: _isCameraReady ? _captureIris : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "Registered: ${_nameController.text} (Roll: ${_rollController.text})"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Register Student",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reports")),
      body: const Center(child: Text("Reports Page UI goes here")),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: const Center(child: Text("Settings Page UI goes here")),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: const Center(child: Text("Profile Page UI goes here")),
    );
  }
}

// ------------------- Attendance Page -------------------
class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  CameraController? _controller;
  bool _isReady = false;
  late Box<models.OfflineEvent> _attendanceBox;

  @override
  void initState() {
    super.initState();
    _attendanceBox = Hive.box<models.OfflineEvent>('offline_events');
    _initCamera();
  }

  Future<void> _initCamera() async {
    if (cameras.isNotEmpty) {
      _controller = CameraController(cameras[0], ResolutionPreset.medium);
      try {
        await _controller!.initialize();
        if (!mounted) return;
        setState(() {
          _isReady = true;
        });
      } catch (e) {
        print('Camera init error: $e');
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error initializing camera: $e')));
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No cameras available')));
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<XFile?> captureStudentImage() async {
    if (_controller == null || !_controller!.value.isInitialized) return null;
    try {
      final image = await _controller!.takePicture();
      return image;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error capturing image: $e')));
      }
      return null;
    }
  }

  Future<Map<String, dynamic>> sendImageToMLService(XFile image) async {
    final uri = Uri.parse('http://10.0.2.2:8000/recognize'); // Android emulator
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    return jsonDecode(respStr);
  }

  Future<void> scanAttendance() async {
    if (!_isReady) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Scanning student...")));

    final image = await captureStudentImage();
    if (image == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Failed to capture image")));
      return;
    }

    try {
      final result = await sendImageToMLService(image);

      final event = models.OfflineEvent(
        classId: 1,
        studentId: result['status'] == 'ok' ? int.tryParse(result['student_id'].toString()) : null,
        method: 'iris',
        confidence: result['confidence'] != null
            ? double.tryParse(result['confidence'].toString())
            : null,
        imagePath: image.path,
        timestamp: DateTime.now(),
      );

      _attendanceBox.add(event);

      if (result['status'] == 'ok') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Attendance marked for student ${result['student_id']} (Confidence: ${result['confidence'].toStringAsFixed(2)})"),
              backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("No matching student found"),
              backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Error scanning student: $e"),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Take Attendance")),
      body: Stack(
        children: [
          _isReady && _controller != null
              ? Positioned.fill(
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: CameraPreview(_controller!),
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Card(
              elevation: 8,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Scan your iris to mark attendance",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.verified_user),
                      label: const Text("Scan Attendance"),
                      onPressed: scanAttendance,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------- Home Page -------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Attendance System",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: "Settings",
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: "Profile",
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome!",
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "Manage your student attendance with ease.",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 40),
            _buildCard(
              context,
              icon: Icons.person_add_alt_1_outlined,
              title: "Register Student",
              subtitle: "Add new students to the system.",
              onTap: () => Navigator.pushNamed(context, '/register'),
            ),
            const SizedBox(height: 20),
            _buildCard(
              context,
              icon: Icons.check_circle_outline,
              title: "Take Attendance",
              subtitle: "Mark daily attendance for students.",
              onTap: () => Navigator.pushNamed(context, '/attendance'),
            ),
            const SizedBox(height: 20),
            _buildCard(
              context,
              icon: Icons.bar_chart_outlined,
              title: "View Reports",
              subtitle: "Access detailed attendance reports.",
              onTap: () => Navigator.pushNamed(context, '/reports'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------- MyApp -------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
      routes: {
        '/register': (context) => const RegisterPage(),
        '/attendance': (context) => const AttendancePage(),
        '/reports': (context) => const ReportsPage(),
        '/settings': (context) => const SettingsPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
