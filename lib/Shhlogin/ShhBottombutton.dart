import 'package:flutter/material.dart';

import 'ShhConnectionResult.dart';

class ShhBottomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(
            top: 20.0,
            left: 70.0,
          ),
          child: ElevatedButton(
            onPressed: null,
            child: Text("Test"),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: 20.0,
            left: 90.0,
          ),
          child: ElevatedButton(
            onPressed: null,
            child: Text("Connect"),
          ),
        ),
      ],
    );
  }
}
