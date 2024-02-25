import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/interfaces.dart';
import 'package:flutter_app/managers/InfoManager.dart';
import 'package:http/http.dart' as http;


class APIManager {

  APIManager({required this.info}); 

  final InfoManager info;

  final String url = "127.0.0.1:8000";

  Future<void> getYourReceipts() async {
    final response = await http
      .get(Uri.http(url, "receipts", {'user': 'myUser'}));

    final body = (jsonDecode(response.body) as Map<String, dynamic>);
    final receiptsJson = (body['receipts'] as List<dynamic>);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      info.setYourReceipts(receiptsJson.map((r) => Receipt.fromJson(r)).toList());
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load receipts');
    }
    return;
  }

  Future<void> getYourAccount() async {
    final response = await http
      .get(Uri.http(url, "login", {'user': 'myUser'}));

    final body = (jsonDecode(response.body) as Map<String, dynamic>);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      info.setYourAccount(User.fromJson(body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user account');
    }
    return;
  }

  Future<void> getAllUsers() async {
    final response = await http
      .get(Uri.http(url, "group", {'user': 'myUser'}));

    final body = (jsonDecode(response.body) as Map<String, dynamic>);
    final usersJson = (body['users'] as List<dynamic>);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      info.setAllUsers(usersJson.map((u) => User.fromJson(u)).toList());
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load group account');
    }
    return;
  }

  Future<ReceiptSnapshot> processReceipt() async {
    var request = new http.MultipartRequest("POST", Uri.http(url, "process"));
    // request.files.add(await http.MultipartFile.fromPath(
    //     'file',
    //     'build/brand_receipt8.jpg'
    // ));
    var response = await request.send();
    return ReceiptSnapshot(subTotal: 0, total: 0, taxes: [], items: [RSItem(qty: 1, desc: "Item Name", price: 1.00)]);
  }

  Future<Receipt> confirmReceipt(ReceiptSnapshot receipt) async {
    var request = new http.MultipartRequest("POST", Uri.http(url, "confirm"));
    var response = await request.send();
    return Receipt(name: "", date: "", assignee: info.myUser, items: [RItem(name: "Item Name", price: 1.00, payers: [])]);
  }
}

