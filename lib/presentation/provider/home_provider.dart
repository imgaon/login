import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:login/data/sources/error_state.dart';
import 'package:login/domain/model/user_model.dart';
import 'package:login/domain/repository/auth_repository.dart';
import 'package:login/util/di.dart';
import 'package:login/util/shared_preferences.dart';

class HomeProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  HomeProvider({required this.authRepository});

  UserModel? userProfile;

  Future<bool> logout() async {
    final result = await Future.wait([
      prefs.prefs.remove('token'),
      prefs.prefs.remove('userInfo'),
    ]);

    bool allTrue = result.every((element) => element == true);

    return allTrue;
  }

  Future<void> getUserProfile() async {
    final result = await authRepository.getUserProfile();

    if (result.isRight()) {
      userProfile = result.rightResult();
      di.set(userProfile);
    }

    if (result.isLeft() && result.leftResult() == ErrorState.expiredToken) {
      final stringUserInfo = prefs.prefs.getString('userInfo');
      if (stringUserInfo == null) return;

      final Map<String, dynamic> decodeUserInfo = jsonDecode(stringUserInfo);
      final Map<String, String> userInfo = decodeUserInfo.map((key, val) => MapEntry(key.toString(), val.toString()));

      await authRepository.login(userInfo: userInfo);
      final result = await authRepository.getUserProfile();

      if (result.isRight()) {
        userProfile = result.rightResult();
        di.set(userProfile);
      }
    }

    notifyListeners();
  }
}