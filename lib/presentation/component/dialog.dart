import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login/data/sources/error_state.dart';

void showAlert(BuildContext context, String title, ErrorState result) => showCupertinoDialog(
  context: context,
  builder: (context) => CupertinoAlertDialog(
    title: Text(title, style: const TextStyle(fontFamily: 'preten')),
    content: Text(result.message, style: const TextStyle(fontFamily: 'preten')),
    actions: [
      CupertinoDialogAction(
        isDefaultAction: true,
        child: const Text('확인', style: TextStyle(color: Colors.black, fontFamily: 'preten')),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  ),
);