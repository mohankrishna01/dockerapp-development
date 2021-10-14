import 'dart:async';

import 'package:docker_app/Dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ssh2/ssh2.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class InputTextField extends StatelessWidget {
  var client;

  InputTextField({
    this.client,
  });
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: "ff");
    TextEditingController hostController =
        TextEditingController(text: "192.168.43.6");
    TextEditingController portController = TextEditingController(text: "22");
    TextEditingController userController = TextEditingController(text: "root");
    TextEditingController pasController = TextEditingController(text: "redhat");
    final _formKey = GlobalKey<FormState>();

    final RoundedLoadingButtonController _btnController =
        RoundedLoadingButtonController();

    void _doSomething() async {
      Timer(
        Duration(),
        () async {
          if (_formKey.currentState!.validate()) {
            bool errorshow = false;
            var connectionresult;

            var host = hostController.text;
            var port = portController.text;
            var username = userController.text;
            var password = pasController.text;
            var name = nameController.text;

            client = SSHClient(
                host: host,
                port: int.parse(port),
                username: username,
                passwordOrKey: password);

            try {
              await client.connect();
            } on PlatformException catch (e) {
              connectionresult = e.code;
              print(connectionresult);
              var val = connectionresult;
              errorshow = val.toLowerCase() == 'connection_failure';
            }
            var dockerstatus;
            try {
              dockerstatus =
                  await client.execute("docker ps &> /dev/null ; echo \$?");
            } catch (e) {
              print(e);
            }

            if (errorshow == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Row(
                    children: [
                      Text(
                        "Authentication failed ",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.error,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              );

              _btnController.error();
              Timer(
                Duration(seconds: 4),
                () {
                  _btnController.reset();
                },
              );
            } else if (int.parse(dockerstatus) == 1) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Row(
                    children: [
                      Text(
                        "Docker ",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.error,
                        color: Colors.white,
                      ),
                      Text(
                        " (Check docker service)",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
              _btnController.error();
              Timer(
                Duration(seconds: 4),
                () {
                  _btnController.reset();
                },
              );
            } else {
              _btnController.success();

              Timer(
                Duration(seconds: 5),
                () {
                  _btnController.reset();
                },
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardUi(
                    client: client,
                    name: name,
                  ),
                ),
              );
            }

            if (errorshow == true || int.parse(dockerstatus) == 1) {
              Null;
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Session connected"),
                ),
              );
            }
          } else {
            _btnController.error();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red[400],
                content: Text(
                  "Please complete all required fields",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
            Timer(Duration(seconds: 5), () {
              _btnController.reset();
            });
          }
        },
      );
    }

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: [
          Container(
            width: 350,
            child: Column(
              children: [
                TextFormField(
                  validator: (namecontroller) {
                    if (namecontroller!.isEmpty) {
                      return ('Name is required');
                    }
                    return null;
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  validator: (namecontroller) {
                    if (namecontroller!.isEmpty) {
                      return ('Host is required');
                    }
                    return null;
                  },
                  controller: hostController,
                  decoration: InputDecoration(
                    labelText: "Host",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  validator: (namecontroller) {
                    if (namecontroller!.isEmpty) {
                      return ('Port is required');
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: portController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    labelText: "Port",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  validator: (namecontroller) {
                    if (namecontroller!.isEmpty) {
                      return ('Username is required');
                    }
                    return null;
                  },
                  controller: userController,
                  decoration: InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  validator: (namecontroller) {
                    if (namecontroller!.isEmpty) {
                      return ('Password is required');
                    }
                    return null;
                  },
                  obscureText: true,
                  controller: pasController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: RoundedLoadingButton(
                    width: 100.0,
                    child:
                        Text('connect', style: TextStyle(color: Colors.white)),
                    controller: _btnController,
                    onPressed: _doSomething,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
