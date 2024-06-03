import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login/data/sources/error_state.dart';
import 'package:login/domain/model/user_model.dart';
import 'package:login/domain/repository/auth_repository.dart';
import 'package:login/util/di.dart';
import 'package:login/util/shared_preferences.dart';

class EditUserProfileProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  EditUserProfileProvider({required this.authRepository});

  late TextEditingController username;
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController height;
  late TextEditingController weight;
  bool emailError = false;
  bool heightError = false;
  bool weightError = false;

  Future<ErrorState> editUserData() async {
    final stringUserAccount = prefs.prefs.getString('userInfo') ?? '';
    final userAccount = jsonDecode(stringUserAccount);
    final userData = di.get<UserModel>();

    print(userData);

    heightError = email.text.isEmpty ? false : !RegExp(r"^[0-9]+(\.[0-9]+)?$").hasMatch(height.text);
    weightError = email.text.isEmpty ? false : !RegExp(r"^[0-9]+(\.[0-9]+)?$").hasMatch(weight.text);
    emailError = email.text.isEmpty ? false : !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]$").hasMatch(email.text);


    if (height.text.isEmpty && userData.height == null) return ErrorState.heightOrWeightIsNull;
    if (weight.text.isEmpty && userData.weight == null) return ErrorState.heightOrWeightIsNull;

    if (!emailError && !heightError && !weightError) {
      print('여기');

      Map<String, dynamic> userInfo = {
        "username" : username.text.isEmpty ? userAccount['identity'] : username.text,
        "email" : email.text.isEmpty ? userData.email : email.text,
        "password" : password.text.isEmpty ? userAccount['password'] : password.text,
        'height' : height.text.isEmpty ? userData.height : double.parse(height.text),
        'weight' : weight.text.isEmpty ? userData.weight : double.parse(weight.text),
      };

      print(userInfo);

      final newUserInfo = {
        'identity' : userInfo['username'],
        'password' : userInfo['password'],
      };

      prefs.prefs.setString('userInfo', jsonEncode(newUserInfo));

      final result = await authRepository.update(userInfo: userInfo);

      return result;
    }

    notifyListeners();
    return ErrorState.error;
  }



}