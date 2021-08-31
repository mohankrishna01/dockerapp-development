import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Fabutton extends StatefulWidget {
  var sshclient;
  Fabutton({this.sshclient});

  @override
  _FabuttonState createState() => _FabuttonState();
}

class _FabuttonState extends State<Fabutton> {
  TextEditingController containernameController = TextEditingController();
  TextEditingController imagenameController = TextEditingController();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  final _formKey = GlobalKey<FormState>();

  var containername;
  var imagename;

  void _doSomething() async {
    Timer(
      Duration(),
      () async {
        if (_formKey.currentState!.validate()) {
          var tcresult;
          if (containername == null) {
            tcresult =
                await widget.sshclient.execute("docker run -dit $imagename");
          } else if (containername != null) {
            tcresult = await widget.sshclient
                .execute("docker run -dit --name $containername $imagename");
          }

          if (tcresult.hashCode == 1) {
            _btnController.error();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Failed : Not Created"),
              ),
            );
            Timer(
              Duration(seconds: 4),
              () {
                _btnController.reset();
              },
            );
          } else {
            _btnController.success();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Container Created Successfully"),
              ),
            );
            Timer(
              Duration(seconds: 3),
              () {
                _btnController.reset();
              },
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
          Timer(
            Duration(seconds: 3),
            () {
              _btnController.reset();
            },
          );
        }
        containernameController.clear();
        imagenameController.clear();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Container"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: 10.0),
            width: 350.0,
            child: ListView(
              children: [
                TextField(
                  controller: containernameController,
                  onChanged: (value) {
                    containername = value;
                  },
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  validator: (namecontroller) {
                    if (namecontroller!.isEmpty) {
                      return ('Image name is required');
                    }
                    return null;
                  },
                  controller: imagenameController,
                  onChanged: (value) {
                    imagename = value;
                  },
                  decoration: InputDecoration(
                    labelText: "Image name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 13.0,
                ),
                Container(
                  child: RoundedLoadingButton(
                    height: 45.0,
                    width: 98.0,
                    child: Text(
                      'create',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.5,
                      ),
                    ),
                    controller: _btnController,
                    onPressed: _doSomething,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
