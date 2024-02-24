

import 'package:flutter/material.dart';

class Receipt {
  final String name;
  final String date;
  final User assignee;
  final List<RItem> items;

  Receipt({required this.name, required this.date, required this.assignee, required this.items});

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String name,
        'date': String date,
        'assignee': Map<String, dynamic> assignee,
        'items': List<dynamic> items
      } =>
        Receipt(
          name: name,
          date: date,
          assignee: User.fromJson(assignee),
          items: items.map((i) => RItem.fromJson(i)).toList()
        ),
      _ => throw const FormatException('Failed to load receipt.'),
    };
  }
}

class User {
  final String uuid;
  final String name;
  final Color color;

  User({required this.uuid, required this.name, required this.color});

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'uuid': String uuid,
        'name': String name,
        'groupIndex': int groupIndex // TODO FIX
      } =>
        User(
          uuid: uuid,
          name: name,
          color: getColor(groupIndex)
        ),
      _ => throw const FormatException('Failed to load user.'),
    };
  }

  String getInitials() {
    return name.split(' ').map((e) => e[0].toUpperCase()).toList().join("");
  }
}

class RItem {
  final String name;
  final double price;
  final List<User> payers;

  RItem({required this.name, required this.price, required this.payers});

  factory RItem.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String name,
        'price': double price,
        'payers': List<dynamic> payers
      } =>
        RItem(
          name: name,
          price: price,
          payers: payers.map((i) => User.fromJson(i)).toList()
        ),
      _ => throw const FormatException('Failed to load RItem.'),
    };
  }
}

class Group {
  final List<User> members;
  final String name;

  Group({required this.members, required this.name});

  factory Group.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String name,
        'members': List<dynamic> members
      } =>
        Group(
          name: name,
          members: members.map((i) => User.fromJson(i)).toList()
        ),
      _ => throw const FormatException('Failed to load Group.'),
    };
  }
}

Color getColor(int groupIndex) {
  switch (groupIndex) {
    case 0:
      return Colors.red;
    case 1:
      return Colors.orange;
    case 2:
      return Colors.yellow;
    case 3:
      return Colors.green;
    case 4:
      return Colors.blue;
    case 5:
      return Colors.purple;
    case 6:
      return Colors.brown;
    case 7:
      return Colors.deepPurple;
    default:
      return Colors.grey;
  }
}
