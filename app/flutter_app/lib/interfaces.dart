

import 'package:flutter/material.dart';

class Receipt {
  final String name;
  final String date;
  final User assignee;
  final List<RItem> items;

  Receipt({required this.name, required this.date, required this.assignee, required this.items});
}

class User {
  final String uuid;
  final String name;
  final Color color;

  User({required this.uuid, required this.name, required this.color});

  String getInitials() {
    return name.split(' ').map((e) => e[0].toUpperCase()).toList().join("");
  }
}

class RItem {
  final String name;
  final double price;
  final List<User> payers;

  RItem({required this.name, required this.price, required this.payers});
}

class Group {
  final List<User> members;
  final String name;

  Group({required this.members, required this.name});
}
