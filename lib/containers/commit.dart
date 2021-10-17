import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class commitpage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController imagenameController = TextEditingController();

  TextEditingController versionController = TextEditingController();
  var sshclient;
  var name;

  commitpage({this.sshclient, this.name});

  final RoundedLoadingButtonController _createimageController =
      RoundedLoadingButtonController();

  var imagename;
  var version;

  @override
  Widget build(BuildContext context) {
    void _createimage() async {
      if (_formKey.currentState!.validate()) {
        try {
          if (version != null) {
            var result = await sshclient.execute("docker commit" +
                "\t" +
                name.replaceAll("\r", "") +
                "\t" +
                imagename +
                ":" +
                version);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("$imagename image created"),
              ),
            );

            _createimageController.success();

            Timer(Duration(seconds: 1), () {
              try {
                _createimageController.reset();
              } catch (e) {}

              Navigator.of(context).pop();
            });
          } else if (version == null) {
            await sshclient.execute("docker commit" +
                "\t" +
                name.replaceAll("\r", "") +
                "\t" +
                imagename);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("$imagename Image created"),
              ),
            );

            _createimageController.success();

            Timer(
              Duration(seconds: 1),
              () {
                try {
                  _createimageController.reset();
                } catch (e) {}
                Navigator.of(context).pop();
              },
            );
          }
        } catch (e) {
          try {
            _createimageController.error();
            Navigator.of(context).pop();

            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(
                  "Error",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  "Host is down or No internet",
                  textAlign: TextAlign.center,
                ),
              ),
            );

            await sshclient.connect();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Connected"),
              ),
            );
          } catch (e) {}
        }
      } else {
        _createimageController.error();

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
            try {
              _createimageController.reset();
            } catch (e) {}
          },
        );
      }
    }

    return Form(
      key: _formKey,
      child: Container(
        width: 200.0,
        height: 190.0,
        child: Column(
          children: [
            Container(
              height: 70.0,
              child: TextFormField(
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
                  label: Text("Enter image name"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              height: 50.0,
              child: TextField(
                onChanged: (value) {
                  version = value;
                },
                controller: versionController,
                decoration: InputDecoration(
                  label: Text("Enter version"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoundedLoadingButton(
                  height: 37.5,
                  borderRadius: 3.5,
                  successColor: Colors.green,
                  width: 90.0,
                  child: Text(
                    'create',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  controller: _createimageController,
                  onPressed: _createimage,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
