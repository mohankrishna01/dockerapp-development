import 'package:docker_app/Shhlogin/dockerimage.dart';
import 'package:docker_app/Shhlogin/inputtextfeild___ssh-connection.dart';
import 'package:flutter/material.dart';

import 'headlinetext.dart';

class ShhLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          DockerImage(),
          SizedBox(
            height: 20.0,
          ),
          HeadlineText(),
          SizedBox(
            height: 25.0,
          ),
          InputTextField(),
        ],
      ),
    );
  }
}
