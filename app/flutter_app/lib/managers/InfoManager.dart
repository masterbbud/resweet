
import 'package:flutter/material.dart';
import 'package:flutter_app/interfaces.dart';

final User nullUser = User(name: 'User1234567890', color: Colors.amber, uuid: '', username: 'User');

class InfoManager {

  List<Receipt> myReceipts = List<Receipt>.empty();
  String? myToken = null;
  User myUser = nullUser;
  List<User> allUsers = [];

  void setYourReceipts(List<Receipt> receipts) {
    myReceipts = receipts;
  }

  void setYourAccount(User user) {
    myUser = user;
  }

  void setAllUsers(List<User> users) {
    allUsers = users;
  }

  void setYourToken(String token) {
    myToken = token;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! InfoManager) return false;
    final InfoManager otherInfoManager = other;
    return myReceipts == otherInfoManager.myReceipts &&
        myUser == otherInfoManager.myUser &&
        allUsers == otherInfoManager.allUsers;
  }

  bool amINull() => myUser == nullUser;
}