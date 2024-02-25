
import 'package:flutter/material.dart';
import 'package:flutter_app/interfaces.dart';

final User nullUser = User(name: 'User1234567890', color: Colors.amber, uuid: '', username: 'User');

class InfoManager {

  List<Receipt> myReceipts = List<Receipt>.empty();

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
}