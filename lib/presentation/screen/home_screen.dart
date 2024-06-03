import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login/presentation/component/colors.dart';
import 'package:login/presentation/provider/home_provider.dart';
import 'package:login/presentation/screen/bmi_screen.dart';
import 'package:login/presentation/screen/edit_user_profile_screen.dart';
import 'package:login/presentation/screen/login_screen.dart';
import 'package:login/util/di.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeProvider provider = di.get<HomeProvider>();

  void updateScreen() => setState(() {});

  @override
  void initState() {
    provider.addListener(updateScreen);
    provider.getUserProfile();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            userProfile(),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                final result = await provider.logout();

                if (result && mounted) successLogout();
                if (!result) failLogout();
              },
              child: const Text('로그아웃'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditUserProfileScreen()),
              ),
              child: const Text('유저정보수정'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BmiScreen()),
              ),
              child: Text('BMI 계산기'),
            ),
          ],
        ),
      ),
    );
  }

  Widget userProfile() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            userProfileForm('username', provider.userProfile?.username ?? '...'),
            userProfileForm('email', provider.userProfile?.email ?? '...'),
            userProfileForm(
                'height',
                provider.userProfile?.height != null
                    ? '${provider.userProfile!.height.toString()} cm'
                    : '아직 정보가 없습니다.'),
            userProfileForm(
                'weight',
                provider.userProfile?.weight != null
                    ? '${provider.userProfile!.weight.toString()} kg'
                    : '아직 정보가 없습니다.'),
          ],
        ),
      );

  Widget userProfileForm(String title, String value) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '$title :',
                  style: const TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                )
              ],
            ),
          ),
          const Divider(height: 1)
        ],
      );

  void successLogout() => showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('로그아웃'),
          content: const Text('로그아웃 되었습니다.'),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('확인', style: TextStyle(color: Colors.black, fontFamily: 'preten')),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            )
          ],
        ),
      );

  void failLogout() => showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('로그아웃'),
          content: const Text('로그아웃에 실패하였습니다.'),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('확인', style: TextStyle(color: Colors.black, fontFamily: 'preten')),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
}
