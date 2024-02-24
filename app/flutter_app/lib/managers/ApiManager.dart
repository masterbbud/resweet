import 'dart:convert';

import 'package:flutter_app/interfaces.dart';
import 'package:http/http.dart' as http;


class APIManager {

  final String url = "127.0.0.1:8000";

  Future<List<Receipt>> getYourReceipts() async {
    print(Uri.http(url, "receipts", {'user': 'myUser'}).toString());
    final response = await http
      .get(Uri.http(url, "receipts", {'user': 'myUser'}));

    final body = (jsonDecode(response.body) as Map<String, dynamic>);
    final receiptsJson = (body['receipts'] as List<dynamic>);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return receiptsJson.map((r) => Receipt.fromJson(r)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load receipts');
    }
  }
}

