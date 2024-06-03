import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:login/data/sources/error_state.dart';
import 'package:login/domain/repository/auth_repository.dart';
import 'package:login/util/di.dart';
import 'package:login/util/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  LoginProvider({required this.authRepository});

  late TextEditingController username;
  late TextEditingController password;
  bool usernameError = false;
  bool passwordError = false;

  Future<ErrorState> login() async {
    usernameError = username.text.isEmpty;
    passwordError = password.text.isEmpty;

    if (!usernameError && !passwordError) {
      final Map<String, String> userInfo = {
        'identity' : username.text,
        'password' : password.text,
      };

      final result = await authRepository.login(userInfo: userInfo);
      if (result.statusCode == 200) prefs.prefs.setString('userInfo', jsonEncode(userInfo));

      return result;
    }

    notifyListeners();
    return ErrorState.error;
  }



}