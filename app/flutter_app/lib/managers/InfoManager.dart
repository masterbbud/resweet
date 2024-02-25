
import 'package:flutter/material.dart';
import 'package:flutter_app/interfaces.dart';

final User nullUser = User(name: '', color: Colors.white, uuid: '', username: '');

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