import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../main.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  CameraController? _controller;
  bool _isReady = false;
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
        setState(() => _isReady = true);
      } catch (e) {
        print('Camera init error: $e');
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error initializing camera: $e')));
      }
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No cameras available')));
    }
  }

  void _switchCamera() {
    if (cameras.length > 1) {
      _currentCameraIndex = (_currentCameraIndex + 1) % cameras.length;
      _initCamera(_currentCameraIndex);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No second camera found')));
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
      appBar: AppBar(title: const Text("Take Attendance")),
      body: Stack(
        children: [
          _isReady && _controller != null
              ? Positioned.fill(child: AspectRatio(aspectRatio: _controller!.value.aspectRatio, child: CameraPreview(_controller!)))
              : const Center(child: CircularProgressIndicator()),
          Positioned(
            top: 40,
            right: 20,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.deepPurple,
              onPressed: _switchCamera,
              child: const Icon(Icons.cameraswitch),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Scan your iris to mark attendance", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.verified_user),
                      label: const Text("Scan Attendance"),
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Scanning student..."))),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
