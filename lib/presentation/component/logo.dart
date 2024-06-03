import 'package:flutter/material.dart';
import 'package:login/presentation/component/colors.dart';

Widget logo() => const Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text(
      'my',
      style: TextStyle(
        color: primary,
        fontSize: 28,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.3,
      ),
    ),
    Text(
      '_health_',
      style: TextStyle(
        color: primary,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
    ),
    Text(
      'data',
      style: TextStyle(
        color: primary,
        fontSize: 28,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.3,
      ),
    )
  ],
);