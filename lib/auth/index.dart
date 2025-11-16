import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  static final Auth _instance = Auth._internal(FlutterSecureStorage());
  // static final Auth _instance = new Auth._internal();
  final FlutterSecureStorage storage;
  String? accessToken;
  String? refreshToken;

  String? firebaseToken;

  // get isLoggedIn => accessToken != null && user != null;

  static Auth instance() => _instance;

  Auth._internal(this.storage);


  Future initialize() async {

    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('first_run') ?? true) {
      await storage.deleteAll();
      prefs.setBool('first_run', false);
    }


    accessToken = await storage.read(key: "access_token");

    firebaseToken = await storage.read(key: "fcm_token");
  }

  Future saveAccessToken(String accessToken) async {
    this.accessToken = accessToken;
    await storage.write(key: "access_token", value: accessToken);
  }

  // static bool loggedIn() => Auth.instance().isLoggedIn;
}
