import 'package:docker_app/Shhlogin/dockerimage.dart';
import 'package:docker_app/Shhlogin/headlinetext.dart';
import 'package:docker_app/Shhlogin/inputtextfeild___ssh-connection.dart';
import 'package:flutter/material.dart';

class ShhLoginPage extends StatefulWidget {
  @override
  _ShhLoginPageState createState() => _ShhLoginPageState();
}

class _ShhLoginPageState extends State<ShhLoginPage> {
  var client;

  TextEditingController nameController = TextEditingController();
  TextEditingController hostController = TextEditingController();
  TextEditingController portController = TextEditingController(text: "22");
  TextEditingController userController = TextEditingController();
  TextEditingController pasController = TextEditingController();

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
          InputTextField(
            client: client,
          )
        ],
      ),
    );
  }
}
