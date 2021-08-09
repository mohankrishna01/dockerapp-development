import 'package:docker_app/Shhlogin/ShhConnectionResult.dart';
import 'package:docker_app/Shhlogin/dockerimage.dart';
import 'package:docker_app/Shhlogin/inputtextfeild.dart';
import 'package:flutter/material.dart';
import 'ShhBottombutton.dart';
import 'headlinetext.dart';

class ShhLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          DockerImage(),
          SizedBox(
            height: 15.0,
          ),
          HeadlineText(),
          SizedBox(
            height: 20.0,
          ),
          InputTextField(),
          ShhBottomButton(),
          SizedBox(
            height: 20.0,
          ),
          //  ShhLoginConnection(),
        ],
      ),
    );
  }
}
