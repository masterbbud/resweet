import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_app/interfaces.dart';
import 'package:flutter_app/managers/InfoManager.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'ApiManager_web.dart' as p
  if (dart.library.io) 'ApiManager_io.dart';


class APIManager {

  APIManager({required this.info}); 

  final InfoManager info;

  //final String url = "resweet-zr7u3u4ibq-uc.a.run.app";
  final String url = "127.0.0.1:8000";

  Future<void> getYourReceipts() async {
    final response = await http
      .get(Uri.http(url, "api/receipt"), headers: {'token': info.myToken ?? ''});

    if (response.statusCode != 200) return;

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
      .get(Uri.http(url, "api/user"), headers: {'token': info.myToken ?? ''});

    if (response.statusCode != 200) return;

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
      .get(Uri.http(url, "group"), headers: {'token': info.myToken ?? ''});

    if (response.statusCode != 200) return;

    final body = (jsonDecode(response.body) as Map<String, dynamic>);
    final usersJson = (body['members'] as List<dynamic>);

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

  Future<String?> signup(String username, String display, String password) async {
    final uri = Uri.http(url, "api/user");
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'username': username,
      'display_name': display,
      'password': password
    });
    final res = await http.post(uri, headers: headers, body: body);

    if (res.statusCode != 200) {
      return null;
    }

    return await login(username, password);
  }

  Future<String?> login(String username, String password) async {
    final uri = Uri.http(url, "api/auth");
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'username': username,
      'password': password
    });
    final res = await http.post(uri, headers: headers, body: body);

    if (res.statusCode != 200) {
      return null;
    }

    return jsonDecode(res.body);
  }

  Future<ReceiptSnapshot> processReceipt(XFile f) async => p.processReceipt(f);


  Future<Receipt> confirmReceipt(ReceiptSnapshot receipt, bool doScale, String name, User assignee) async {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    double taxMod;
    if (doScale) {
      double total = 0.0;
      for (RSItem rsi in receipt.items) {
        total += rsi.price;
      }
      taxMod = receipt.total / total;
    }
    else {
      taxMod = 1.0;
    }
    return Receipt(name: name, date: "${now.year}-${now.month}-${now.day}", assignee: assignee, items: receipt.items.map((i) => i.toRItem(taxMod)).toList());
  }

  Future<Receipt> finalizeReceipt(Receipt receipt) async {
    receipt.items.forEach((item) {
      if (item.payers.length == 0) {
        item.payers.add(receipt.assignee);
      }
    });
    print(jsonEncode(Receipt.toJson(receipt)));
    var request = await http.post(Uri.http(url, "api/receipt"), body: jsonEncode(Receipt.toJson(receipt)), headers: {"Content-Type": "application/json"});
    await getYourReceipts();
    return receipt;
  }

  Future<void> joinWithCode(String code) async {
    final response = await http
      .get(Uri.http(url, "invite/$code"), headers: {'token': info.myToken ?? ''});

    if (response.statusCode != 200) return;

    await getAllUsers();
    await getYourReceipts();
    return;
  }

  Future<List<dynamic>> getLedger() async {
    final response = await http
      .get(Uri.http(url, "api/ledger"), headers: {'token': info.myToken ?? ''});
    
    List<dynamic> entries = (jsonDecode(response.body) as List<dynamic>);
    entries = [{'user': {'name': "Test", 'uuid': 'Test111', 'groupIndex': 10, 'username': 'test username'}, 'balance': 100}];
    List<Map<String, dynamic>> res = [];
    for (dynamic d in entries) {
      res.add({'user': User.fromJson(d['user']), 'balance': d['balance']});
    }
    return res;
  }
}

