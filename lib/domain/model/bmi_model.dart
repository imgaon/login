import 'package:flutter/material.dart';

class BmiModel {
  final String bmiState;
  final IconData icon;


  BmiModel({required this.bmiState, required this.icon});

  @override
  String toString() {
    return 'BmiModel{bmiState: $bmiState}';
  }
}