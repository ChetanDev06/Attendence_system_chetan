import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/db_helper.dart';
import '../main.dart'; // for the cameras list

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollController = TextEditingController();

  CameraController? _controller;
  bool _isCameraReady = false;
  int _currentCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _initCamera(_currentCameraIndex);
  }

  Future<void> _initCamera(int cameraIndex) async {
    if (cameras.isNotEmpty) {
      _controller = CameraController(cameras[cameraIndex], ResolutionPreset.medium);
      try {
        await _controller!.initialize();
        if (!mounted) return;
        setState(() {
          _isCameraReady = true;
        });
      } catch (e) {
        print('Camera init error: $e');
      }
    }
  }

  void _switchCamera() {
    if (cameras.length > 1) {
      _currentCameraIndex = (_currentCameraIndex + 1) % cameras.length;
      _initCamera(_currentCameraIndex);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No second camera found')),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Student")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("Student Details", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
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
                  validator: (value) => value!.isEmpty ? "Please enter the student's name" : null,
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
                  validator: (value) => value!.isEmpty ? "Please enter the roll number" : null,
                ),
                const SizedBox(height: 30),
                Stack(
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 220,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: _isCameraReady && _controller != null
                                    ? CameraPreview(_controller!)
                                    : Container(color: Colors.grey[200], child: const Center(child: Icon(Icons.visibility_outlined, size: 60, color: Colors.deepPurple))),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.camera_alt),
                              label: const Text("Capture Iris"),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Camera opened for iris capture...")));
                              },
                              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                        child: IconButton(icon: const Icon(Icons.cameraswitch, color: Colors.white), onPressed: _switchCamera),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await DBHelper.insertUser({
                        "name": _nameController.text,
                        "roll": _rollController.text,
                        "irisData": "sample_iris_data"
                      });

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Registered: ${_nameController.text} (Roll: ${_rollController.text})"), backgroundColor: Colors.green));

                      _nameController.clear();
                      _rollController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text("Register Student", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
