import 'dart:math';

import 'package:flutter/material.dart';
import 'package:login/domain/model/bmi_model.dart';
import 'package:login/domain/model/user_model.dart';
import 'package:login/util/di.dart';

class BmiProvider extends ChangeNotifier {
  bool haveCalculatedBMI = false;
  late BmiModel userBmiData;

  void bmiCalculator() {
    final UserModel userData = di.get<UserModel>();

    print(userData);

    // final userData = UserModel(email: 'email', username: 'username', height: 180, weight: 120);

    haveCalculatedBMI = true;

    final double? weight = userData.weight;
    final double? height = userData.height != null ? pow((userData.height! / 100), 2) as double : null;

    print(weight);
    print(height);

    if (weight == null || height == null) {
      userBmiData = BmiModel(bmiState: '계산에 실패하였습니다.', icon: Icons.error);
      notifyListeners();
      return;
    }

    final double bmi = weight / height;

    if (bmi < 18.5) userBmiData = BmiModel(bmiState: '저체중', icon: Icons.sentiment_dissatisfied_outlined);
    if (bmi >= 18.5 && bmi <= 24.9 ) userBmiData = BmiModel(bmiState: '정상', icon: Icons.sentiment_satisfied_alt);
    if (bmi >= 25 && bmi <= 29.9) userBmiData = BmiModel(bmiState: '과체중', icon: Icons.sentiment_dissatisfied_outlined);
    if (bmi >= 30) userBmiData = BmiModel(bmiState: '비만', icon: Icons.sentiment_very_dissatisfied_outlined);

    notifyListeners();
  }
}