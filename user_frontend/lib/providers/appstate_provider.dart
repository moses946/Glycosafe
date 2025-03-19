// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';
import 'package:flutter/material.dart';
import 'package:glycosafe_v1/pages/db.dart';

class MyAppState extends ChangeNotifier {
  int defaultPage = 2;
  String email = "mosesmsawaiw@gmail.com";
  String firstName = "Mosases";
  int userId = 1;
  String lastName = "Mwasi";
  String phoneNumber = "0799049229";
  String birthday = '2004-05-07';
  final pages = ["/home2", "/rafiki", "/camera", "/community", "/settings"];
  int threshold = 10000;
  double weight = 50.0;
  final databaseHelper = DatabaseHelper();

  MyAppState() {
    setDetails();
  }

  Future<void> setDetails() async {
    bool dbExists = await databaseHelper.databaseExists();
    if (!dbExists) {
      print("Database does not exist");
      await databaseHelper.database;
      // Handle the case when the database does not exist
      // For example, initialize default values or show an error message
      return;
    }

    var users = await databaseHelper.getProfile();
    if (users.isNotEmpty) {
      print("setting details from database");
      var user = users.last;
      print(user);
      userId = user["user_id"];
      firstName = user["firstName"];
      lastName = user["lastName"];
      email = user["email"];
      phoneNumber = user["phoneNumber"];
      birthday = user['DOB'];
      weight = double.parse(user['weight']);
      notifyListeners();
      print("it set successfully");
    } else {
      print('empty db');
      return;
    }
  }

  Map<String, dynamic> getDetails() {
    var user = {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phoneNumber": phoneNumber,
      "userId": userId,
      "weight": weight
    };
    return user;
  }

  void logout(int reset) {
    defaultPage = reset;
    notifyListeners();
  }

  void setCurrentPage(BuildContext context, int page) {
    if (defaultPage != page) {
      defaultPage = page;
      notifyListeners();
      Navigator.pushReplacementNamed(context, pages[defaultPage]);
    }
  }

  void setEmail(mail) {
    email = mail;
    print(mail);
    notifyListeners();
  }
  void flushDetails(){    
    email = "";
    firstName = "";
    userId = 0;
    lastName = "";
    phoneNumber = "";
    birthday = '';   
    threshold = 0;
    weight = 0;
    notifyListeners();
  }
  void setName(fname, lname) {
    firstName = fname;
    lastName = lname;
    notifyListeners();
  }
}
