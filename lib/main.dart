import 'package:flutter/material.dart';
import 'package:login/data/sources/rest_service.dart';
import 'package:login/domain/repository/auth_repository.dart';
import 'package:login/presentation/provider/bmi_provider.dart';
import 'package:login/presentation/provider/edit_user_profile_provider.dart';
import 'package:login/presentation/provider/home_provider.dart';
import 'package:login/presentation/provider/login_provider.dart';
import 'package:login/presentation/provider/register_provider.dart';
import 'package:login/presentation/screen/bmi_screen.dart';
import 'package:login/presentation/screen/home_screen.dart';
import 'package:login/presentation/screen/login_screen.dart';
import 'package:login/util/di.dart';
import 'package:login/util/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await prefs.init();

  final RestService restService = RestService();

  final AuthRepository authRepository = AuthRepository(restService: restService);

  final LoginProvider loginProvider = LoginProvider(authRepository: authRepository);
  final RegisterProvider registerProvider = RegisterProvider(authRepository: authRepository);
  final HomeProvider homeProvider = HomeProvider(authRepository: authRepository);
  final EditUserProfileProvider editUserProfileProvider = EditUserProfileProvider(authRepository: authRepository);
  final BmiProvider bmiProvider = BmiProvider();

  di.set(loginProvider);
  di.set(registerProvider);
  di.set(homeProvider);
  di.set(editUserProfileProvider);
  di.set(bmiProvider);

  final String? token = prefs.prefs.getString('token');

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'preten',
      ),
      home: token == null ? const LoginScreen() : const HomeScreen(),
    )
  );
}