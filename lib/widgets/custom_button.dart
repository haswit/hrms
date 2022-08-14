// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:hrms_app/constants.dart';

class CustomButton extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final onclickFunction;
  final String text;
  const CustomButton(
      {Key? key, required this.onclickFunction, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: RaisedButton(
        onPressed: onclickFunction,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
        padding: const EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.7)),
          child: Container(
            decoration: BoxDecoration(
                color: ConstantStrings.kPrimaryColor,
                borderRadius: BorderRadius.circular(10)),
            width: MediaQuery.of(context).size.width,
            constraints: const BoxConstraints(minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}
