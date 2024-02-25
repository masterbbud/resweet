

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

  double getTotal() {
    double total = 0;
    items.forEach((i) => total += i.price);
    return total;
  }

  double getPriceForUser(User user) {
    double total = 0;
    items.forEach((i) {
      if (i.payers.any((u) => u.uuid == user.uuid)) {
        total += i.price / i.payers.length;
      }
    });
    return total;
  }

  static Map<String, dynamic> toJson(Receipt value) =>
      {'name': value.name, 'date_entered': value.date, 'assignee_id': value.assignee.uuid, 'items': value.items.map((p) => RItem.toJson(p)).toList()};
}

class User {
  final String uuid;
  final String name;
  final Color color;
  final String username;

  User({required this.uuid, required this.name, required this.color, required this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'uuid': String uuid,
        'name': String name,
        'groupIndex': int groupIndex, // TODO FIX
        'username': String username,
      } =>
        User(
          uuid: uuid,
          name: name,
          color: getColor(groupIndex),
          username: username
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

  static Map<String, dynamic> toJson(RItem value) =>
      {'name': value.name, 'price': value.price, 'payer_ids': value.payers.map((p) => p.uuid).toList()};
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

class ReceiptSnapshot {
  final double subTotal;
  final double total;
  final List<double> taxes;
  final List<RSItem> items;

  const ReceiptSnapshot({
    required this.subTotal,
    required this.total,
    required this.taxes,
    required this.items,
  });

  factory ReceiptSnapshot.fromMap(Map<String, dynamic> json) =>
    ReceiptSnapshot(
        subTotal: double.parse(json['subTotal']),
        total: double.parse(json['total']),
        taxes: json['taxes'].map<double>((t) => double.parse('$t')).toList(),
        items: json['lineItems'].map<RSItem>((li) => RSItem.fromMap(li)).toList()
    );

  @override
  String toString() {
    return 'ReceiptSnapshot{subTotal: $subTotal, total: $total, taxes: $taxes, items: $items}';
  }

  bool isNone() =>
      subTotal == 0 && total == 0 && items.isEmpty;

}

class RSItem {
  final int qty;
  final String desc;
  final double price;

  const RSItem({
    required this.qty,
    required this.desc,
    required this.price
  });

  factory RSItem.fromMap(Map<String, dynamic> json) =>
      RSItem(qty: json['qty'], desc: json['descClean'], price: double.parse(json['lineTotal']));
  
  RItem toRItem() {
    return RItem(name: desc, price: price, payers: []);
  }
}