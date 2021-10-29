import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Pullimagepage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController imagenameController = TextEditingController();

  var sshclient;

  Pullimagepage({this.sshclient});

  final RoundedLoadingButtonController _createimageController =
      RoundedLoadingButtonController();

  var imagename;

  @override
  Widget build(BuildContext context) {
    void _createimage() async {
      if (_formKey.currentState!.validate()) {
        try {
          var result = await sshclient.execute("docker pull $imagename");

          if (result.hashCode == 30082219) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text("Failed"),
              ),
            );
            _createimageController.error();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text("Pulled successful"),
              ),
            );
            _createimageController.success();
            Navigator.pop(context);
          }
          try {
            Timer(
              Duration(seconds: 2),
              () {
                try {
                  _createimageController.reset();
                } catch (e) {}
              },
            );
          } catch (e) {}
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoundedLoadingButton(
                  height: 37.5,
                  borderRadius: 18.0,
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
            ),
            SizedBox(
              height: 12.0,
            ),
            Text(
              "*Download may take some time (depending upon internet speed). \n so please be patient.",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
