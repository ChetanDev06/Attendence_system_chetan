import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

Future<Map?> captureAndRecognize() async {
  final picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.camera);
  if (image == null) return null;

  var req = http.MultipartRequest(
      'POST', Uri.parse("http://10.0.2.2:8001/recognize"));
  req.files.add(await http.MultipartFile.fromPath('file', image.path));

  var res = await req.send();
  var body = await res.stream.bytesToString();
  return jsonDecode(body);
}
