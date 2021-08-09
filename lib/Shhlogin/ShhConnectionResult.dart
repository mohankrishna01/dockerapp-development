import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ShhLoginConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 25.0,
          width: 200.0,
          child: Text(
            "Test Succesful",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
