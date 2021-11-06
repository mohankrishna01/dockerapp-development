import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Imagetag extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController imagenameController = TextEditingController();

  TextEditingController versionController = TextEditingController();
  var sshclient;
  var imageid;
  var imagetag;
  Imagetag({this.sshclient, this.imageid, this.imagetag});

  final RoundedLoadingButtonController _changeimagenameController =
      RoundedLoadingButtonController();

  var imagename;
  var version;

  @override
  Widget build(BuildContext context) {
    void _changeimagename() async {
      if (_formKey.currentState!.validate()) {
        try {
          var result = await sshclient.execute(
            "docker tag" + "\t" + imageid.replaceAll("\r", " \t$imagename"),
          );

          var namecheck = await sshclient.execute(
              " docker images $imagename  --format '{{json .Repository}}:{{json .Tag}}'");
          print(imagename.runtimeType);
          print(namecheck.runtimeType);
          print(imagename.contains(namecheck.replaceAll("\r", "")));

          if (namecheck
              .replaceAll("\r", "")
              .contains(imagename.toLowerCase())) {
            _changeimagenameController.success();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("$imagename name changed"),
              ),
            );
          } else {
            _changeimagenameController.error();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  "$imagename name change failed",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }
          Timer(Duration(seconds: 1), () {
            try {
              _changeimagenameController.reset();
            } catch (e) {}

            Navigator.of(context).pop();
          });
        } catch (e) {
          try {
            _changeimagenameController.error();
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
        _changeimagenameController.error();

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
              _changeimagenameController.reset();
            } catch (e) {}
          },
        );
      }
    }

    return Form(
      key: _formKey,
      child: Container(
        width: 200.0,
        height: 135.0,
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
                    'change',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  controller: _changeimagenameController,
                  onPressed: _changeimagename,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
