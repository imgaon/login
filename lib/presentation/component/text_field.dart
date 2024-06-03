import 'package:flutter/material.dart';

Widget textField(
        {required BuildContext context,
        required String hintText,
        required TextEditingController controller,
        bool error = false,
        String errorText = "필수 입력값입니다.",
        bool obscureText = false}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 5
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
                hintText: hintText,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            error ? errorText : '',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.end,
          ),
        )
      ],
    );
