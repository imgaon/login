import 'package:flutter/cupertino.dart';
import 'package:login/data/sources/error_state.dart';
import 'package:login/domain/repository/auth_repository.dart';

class RegisterProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  RegisterProvider({required this.authRepository});

  late TextEditingController username;
  late TextEditingController email;
  late TextEditingController password;
  bool usernameError = false;
  bool emailError = false;
  bool passwordError = false;

  Future<ErrorState> register() async {
    usernameError = username.text.isEmpty;
    emailError =
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email.text);

    passwordError = password.text.isEmpty;

    if (!usernameError && !emailError && !passwordError) {
      final Map<String, String> userInfo = {
        "username": username.text,
        "email": email.text,
        "password": password.text,
      };

      final result = await authRepository.register(userInfo: userInfo);

      return result;
    }

    notifyListeners();
    return ErrorState.error;
  }
}
