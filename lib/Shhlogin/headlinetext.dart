import 'package:flutter/material.dart';

class HeadlineText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "Enter Server Details",
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
}
