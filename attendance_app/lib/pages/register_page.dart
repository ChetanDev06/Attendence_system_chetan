import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    if (cameras!.isNotEmpty) {
      _controller = CameraController(
        cameras![0], // use first camera
        ResolutionPreset.medium,
      );
      await _controller!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    if (_controller != null && _controller!.value.isInitialized) {
      final image = await _controller!.takePicture();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Photo saved: ${image.path}")),
      );
      // Later: send `image.path` to your iris recognition AI/ML model
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Student")),
      body: _isCameraInitialized
          ? Column(
              children: [
                Expanded(
                  child: CameraPreview(_controller!),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: _capturePhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Capture Iris"),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
