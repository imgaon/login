import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login/data/sources/error_state.dart';
import 'package:login/presentation/component/colors.dart';
import 'package:login/presentation/component/logo.dart';
import 'package:login/presentation/component/text_field.dart';
import 'package:login/presentation/provider/register_provider.dart';
import 'package:login/util/di.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterProvider provider = di.get<RegisterProvider>();

  void updateScreen() => setState(() {});

  @override
  void initState() {
    provider.username = TextEditingController();
    provider.email = TextEditingController();
    provider.password = TextEditingController();
    provider.addListener(updateScreen);
    super.initState();
  }

  @override
  void dispose() {
    provider.username.dispose();
    provider.email.dispose();
    provider.password.dispose();
    provider.removeListener(updateScreen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: 50,
                left: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios),
                ),
              ),
              Padding(
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
                        hintText: 'email',
                        controller: provider.email,
                        error: provider.emailError,
                        errorText: '이메일 형식이 잘못되었습니다.'),
                    textField(
                      context: context,
                      hintText: 'password',
                      controller: provider.password,
                      error: provider.passwordError,
                      obscureText: true
                    ),
                    registerButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget registerButton() => GestureDetector(
        onTap: () async {
          final result = await provider.register();

          if (result.statusCode == 200) {
            successSignUp();
          } else if (!provider.usernameError && !provider.emailError && !provider.passwordError) {
            showAlert(result);
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
              'Sign up',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),
        ),
      );

  void showAlert(ErrorState result) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('회원가입 실패', style: TextStyle(fontFamily: 'preten')),
        content: Text(
          result.message,
          style: const TextStyle(fontFamily: 'preten'),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('확인', style: TextStyle(color: Colors.black, fontFamily: 'preten')),
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void successSignUp() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('회원가입 성공', style: TextStyle(fontFamily: 'preten')),
        content: const Text(
          '회원가입이 정상적으로 완료되었습니다.',
          style: TextStyle(fontFamily: 'preten'),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('확인', style: TextStyle(color: Colors.black, fontFamily: 'preten')),
            onPressed: () async {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
