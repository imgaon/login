import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login/data/sources/error_state.dart';
import 'package:login/presentation/component/colors.dart';
import 'package:login/presentation/component/dialog.dart';
import 'package:login/presentation/component/logo.dart';
import 'package:login/presentation/component/text_field.dart';
import 'package:login/presentation/provider/login_provider.dart';
import 'package:login/presentation/screen/home_screen.dart';
import 'package:login/presentation/screen/register_screen.dart';
import 'package:login/util/di.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginProvider provider = di.get<LoginProvider>();

  void updateScreen() => setState(() {});

  @override
  void initState() {
    provider.username = TextEditingController();
    provider.password = TextEditingController();
    provider.addListener(updateScreen);
    super.initState();
  }

  @override
  void dispose() {
    provider.username.dispose();
    provider.password.dispose();
    provider.addListener(updateScreen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                logo(),
                const SizedBox(height: 50),
                textField(
                  context: context,
                  hintText: 'username',
                  controller: provider.username,
                  error: provider.usernameError,
                ),
                textField(
                  context: context,
                  hintText: 'password',
                  controller: provider.password,
                  error: provider.passwordError,
                  obscureText: true
                ),
                loginButton(),
                const SizedBox(height: 30),
                signUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton() => GestureDetector(
        onTap: () async {
          final result = await provider.login();

          if (result.statusCode == 200 && mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          } else if (!provider.usernameError && !provider.passwordError && mounted) {
            showAlert(context , '로그인 실패', result);
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: primary.withOpacity(0.5), blurRadius: 10)],
          ),
          child: const Center(
            child: Text(
              'Sign in',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),
        ),
      );

  Widget signUpButton() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'Don\'t have an account?',
          ),
          GestureDetector(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
            child: const Text(
              ' Sign up',
              style: TextStyle(
                color: primary,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          )
        ],
      );
}
