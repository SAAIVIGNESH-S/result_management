import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Data with ChangeNotifier {
  String email;
  String accessToken;
  String role;
  String id;
  bool isLoggedIn;
  String loginType;

  Future<void> storeInternally() async {
    final prefs = await SharedPreferences.getInstance();
    final appData = json.encode({
      'email': getEmail,
      'accessToken': getAccessToken,
      'role': getRole,
      'id': getId,
      'isLoggedIn': getIsLoggedIn,
      'loginType': getLoginType,
    });
    prefs.setString("data", appData);

    print(appData);
    print('app data stored internally');
  }

  Future<bool> tryAutoLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    print("Auto Login");
    if (!prefs.containsKey("data")) {
      return false;
    } else {
      final extractedData = json.decode(prefs.getString("data"));
      print(extractedData);
      updateAllData(extractedData);
      return true;
    }
  }

  void updateData({
    @required obtainedAccessToken,
    @required obtainedEmail,
    @required obtainedId,
    @required obtainedRole,
    @required obtainedType,
    @required obtainedLoggedIn,
  }) {
    accessToken = obtainedAccessToken;
    email = obtainedEmail;
    id = obtainedId;
    role = obtainedRole;
    loginType = obtainedType;
    isLoggedIn = obtainedLoggedIn;
    notifyListeners();
    storeInternally();
  }

  void updateAllData(var extractedData) {
    email = extractedData["email"];
    accessToken = extractedData["accessToken"];
    role = extractedData["role"];
    id = extractedData["id"];
    isLoggedIn = extractedData["isLoggedIn"];
    loginType = extractedData["loginType"];
    notifyListeners();
  }

  void updateEmail(String obtainedEmail) {
    email = obtainedEmail;
    notifyListeners();
    storeInternally();
  }

  void updateAccessToken(String obtainedAccessToken) {
    accessToken = obtainedAccessToken;
    notifyListeners();
    storeInternally();
  }

  void updateRole(String obtainedRole) {
    role = obtainedRole;
    notifyListeners();
    storeInternally();
  }

  void updateId(String obtainedId) {
    id = obtainedId;
    notifyListeners();
    storeInternally();
  }

  void updateLoggedIn(bool obtainedIsLoggedIn) {
    isLoggedIn = obtainedIsLoggedIn;
    notifyListeners();
    storeInternally();
  }

  void updateLoginType(String obtainedLoginType) {
    loginType = obtainedLoginType;
    notifyListeners();
    storeInternally();
  }

  void clearAllData() {
    email = null;
    accessToken = null;
    role = null;
    id = null;
    isLoggedIn = false;
    loginType = null;

    storeInternally();
  }

  String get getEmail {
    return email;
  }

  String get getAccessToken {
    return accessToken;
  }

  String get getRole {
    return role;
  }

  String get getId {
    return id;
  }

  bool get getIsLoggedIn {
    return isLoggedIn;
  }

  String get getLoginType {
    return loginType;
  }
}
