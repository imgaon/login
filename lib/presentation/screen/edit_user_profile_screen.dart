import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login/data/sources/error_state.dart';
import 'package:login/domain/model/user_model.dart';
import 'package:login/presentation/component/colors.dart';
import 'package:login/presentation/component/dialog.dart';
import 'package:login/presentation/component/logo.dart';
import 'package:login/presentation/component/text_field.dart';
import 'package:login/presentation/provider/edit_user_profile_provider.dart';
import 'package:login/presentation/screen/home_screen.dart';
import 'package:login/util/di.dart';

class EditUserProfileScreen extends StatefulWidget {
  const EditUserProfileScreen({super.key});

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  final EditUserProfileProvider provider = di.get<EditUserProfileProvider>();
  final UserModel? userData = di.get<UserModel>();

  void updateScreen() => setState(() {});

  @override
  void initState() {
    provider.username = TextEditingController();
    provider.email = TextEditingController();
    provider.password = TextEditingController();
    provider.height = TextEditingController();
    provider.weight = TextEditingController();
    provider.addListener(updateScreen);
    super.initState();
  }

  @override
  void dispose() {
    provider.removeListener(updateScreen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 25),
              child: Column(
                children: [
                  logo(),
                  const SizedBox(height: 50),
                  textField(
                    context: context,
                    hintText: userData?.username ?? 'username',
                    controller: provider.username,
                  ),
                  textField(
                    context: context,
                    hintText: userData?.email ?? 'email',
                    controller: provider.email,
                    error: provider.emailError,
                    errorText: '이메일 형식이 잘못되었습니다.',
                  ),
                  textField(
                      context: context,
                      hintText: 'password',
                      controller: provider.password,
                      obscureText: true),
                  textField(
                    context: context,
                    hintText: userData!.height == null ? 'height' : userData!.height.toString(),
                    controller: provider.height,
                    error: provider.heightError,
                    errorText: '입력 형식이 잘못되었습니다.',
                  ),
                  textField(
                      context: context,
                      hintText: userData!.weight == null ? 'weight' : userData!.weight.toString(),
                      controller: provider.weight,
                      error: provider.weightError,
                      errorText: '입력 형식이 잘못되었습니다.'),
                  editButton(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget editButton() => GestureDetector(
        onTap: () async {
          final result = await provider.editUserData();
          if (result.statusCode == 200 && mounted) {
            successEdit();
          } else if (result == ErrorState.heightOrWeightIsNull && mounted) {
            showAlert(context, '회원정보수정', result);
          } else if (!provider.emailError &&
              !provider.weightError &&
              !provider.heightError &&
              mounted) {
            showAlert(context, '회원정보수정', result);
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
              'Edit',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),
        ),
      );

  void successEdit() => showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: const Text('회원정보수정'),
      content: const Text('회원정보가 수정되었습니다.'),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('확인', style: TextStyle(color: Colors.black, fontFamily: 'preten')),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
            );
          },
        )
      ],
    ),
  );
}
