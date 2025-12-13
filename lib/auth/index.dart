import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/models/profile_models.dart';

class Auth {
  static final Auth _instance = Auth._internal(FlutterSecureStorage());
  final FlutterSecureStorage storage;
  String? accessToken;
  String? refreshToken;
  String? sessionId;
  Profile? profile;

  String? firebaseToken;

  get isLoggedIn => accessToken != null && refreshToken != null;

  static Auth instance() => _instance;

  Auth._internal(this.storage);


  Future initialize() async {

    accessToken = await storage.read(key: "access_token");
    refreshToken = await storage.read(key: "refresh_token");
    sessionId = await storage.read(key: "session_id");
    firebaseToken = await storage.read(key: "fcm_token");

    // read profile
    final profileData = await storage.read(key: "profile");
    if (profileData != null) {
      profile = Profile.fromJson(jsonDecode(profileData));
    }
  }

  Future saveAccessToken(String? accessToken) async {
    print("--save access token");
    this.accessToken = accessToken;
    await storage.write(key: "access_token", value: accessToken);
  }

  Future saveRefreshToken(String? refreshToken) async {
    this.refreshToken = refreshToken;
    await storage.write(key: "refresh_token", value: refreshToken);
  }

  Future saveSessionId(String sessionId) async {
    this.sessionId = sessionId;
    await storage.write(key: "session_id", value: sessionId);
  }

  Future saveProfile(Profile profile) async {
    this.profile = profile;
    await storage.write(key: "profile", value: jsonEncode(profile.toJson()));
  }

  void removeAllStorage(){
    print("--remove all storage");
    storage.deleteAll();
    Auth.instance().saveAccessToken(null);
    Auth.instance().saveRefreshToken(null);
  }

  Future logout() async {
    removeAllStorage();
  }

  static bool loggedIn() => Auth.instance().isLoggedIn;
}
