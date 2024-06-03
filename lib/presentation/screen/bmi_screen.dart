import 'package:flutter/material.dart';
import 'package:login/presentation/provider/bmi_provider.dart';
import 'package:login/util/di.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  final BmiProvider provider = di.get<BmiProvider>();

  void updateScreen() => setState(() {});

  @override
  void initState() {
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
      appBar: AppBar(
        title: Text('BMI 계산기'),
      ),
      body: Center(
        child: provider.haveCalculatedBMI ? bmiWidget() : button(),
      ),
    );
  }

  Widget bmiWidget() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(provider.userBmiData.icon, size: 50),
          const SizedBox(height: 30),
          Text(provider.userBmiData.bmiState,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => setState(() {
              provider.haveCalculatedBMI = false;
            }),
            child: Text('초기화'),
          ),
        ],
      );

  Widget button() => ElevatedButton(
        onPressed: () {
          provider.bmiCalculator();
          print(provider.userBmiData);
        },
        child: Text('계산하기'),
      );
}
