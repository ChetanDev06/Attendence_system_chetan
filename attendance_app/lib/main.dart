import 'package:flutter/material.dart';
import 'package:attendance_app/models/offline_event.dart' as models;
import 'package:attendance_app/services/attendance_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:attendance_app/services/offline_service.dart';


void main() async {
  // Ensure Flutter bindings are initialized before any async calls
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(OfflineEventAdapter());

  // Open a Hive box for storing offline events
  await Hive.openBox<OfflineEvent>('offline_events');

  // Optional: test your OfflineEvent model
  testOfflineEvent();

  // Run the app
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            // ✅ ElevatedButton for Capture & Recognize
            ElevatedButton(
              onPressed: () async {
                var result = await captureAndRecognize();
                if (result != null) {
                  // Show result in a simple dialog
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Recognition Result"),
                      content: Text(result.toString()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text("Capture & Recognize"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

void testOfflineEvent() {
  final event = models.OfflineEvent(
    classId: 1,
    studentId: 42,
    method: 'iris',
    confidence: 0.95,
    imagePath: '/path/to/image.png',
    timestamp: DateTime.now(),
  );

  print(event.toJson());
}
