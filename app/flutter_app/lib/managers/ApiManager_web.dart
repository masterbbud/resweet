import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../interfaces.dart';

const String url = "127.0.0.1:8000";

Future<ReceiptSnapshot> processReceipt(XFile file) async {
  final imageBytes = await file.readAsBytes();
  final filename = file.name;

  final request = http.MultipartRequest("POST", Uri.http(url, "ocr/process"))
    ..files.add(http.MultipartFile.fromBytes('file', imageBytes, filename: filename));

  final res = await request.send();

  if (res.statusCode != 200) {
    throw Exception('Failed to process receipt');
  }

  final data = await res.stream.bytesToString();

  return ReceiptSnapshot.fromMap(jsonDecode(data));
}