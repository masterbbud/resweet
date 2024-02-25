import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../interfaces.dart';

const String url = "127.0.0.1:8000";

Future<ReceiptSnapshot> processReceipt(XFile file) async {
  final f = File(file.name);
  final request = http.MultipartRequest("POST", Uri.http(url, "ocr/process"));
  request.files.add(await http.MultipartFile.fromPath('file', f.path));
  final response = await request.send();
  final data = await response.stream.bytesToString();
  return ReceiptSnapshot.fromMap(jsonDecode(data));
}