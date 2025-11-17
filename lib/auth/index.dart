import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  static final Auth _instance = Auth._internal(FlutterSecureStorage());
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
    refreshToken = await storage.read(key: "refresh_token");

    firebaseToken = await storage.read(key: "fcm_token");
  }

  Future saveAccessToken(String accessToken) async {
    print("--save access token");
    this.accessToken = accessToken;
    await storage.write(key: "access_token", value: accessToken);
  }

  Future saveRefreshToken(String refreshToken) async {
    this.refreshToken = refreshToken;
    await storage.write(key: "refresh_token", value: refreshToken);
  }

  // static bool loggedIn() => Auth.instance().isLoggedIn;
}
