import 'dart:async';

import 'package:docker_app/images/imageslist.dart';
import 'package:docker_app/images/pullimage.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Imagesoption extends StatelessWidget {
  var sshclient;

  Imagesoption({this.sshclient});

  @override
  Widget build(BuildContext context) {
    final RoundedLoadingButtonController _deleteallController =
        RoundedLoadingButtonController();

    void _deleteprune() async {
      try {
        var result = await sshclient.execute("docker image prune -f");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Dangling images are deleted"),
          ),
        );

        _deleteallController.success();
        Timer(Duration(milliseconds: 700), () {
          Navigator.of(context).pop();
        });
      } catch (e) {
        try {
          _deleteallController.error();
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
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          "Image(s) List",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01,
              ),
              height: MediaQuery.of(context).size.height * 0.075,
              width: MediaQuery.of(context).size.width * 0.95,
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    iconSize: 25.0,
                    icon: Icon(
                      Icons.add,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            "Create a new image",
                            style: TextStyle(
                              fontSize: 17.0,
                            ),
                          ),
                          content: Pullimagepage(
                            sshclient: sshclient,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    iconSize: 23.0,
                    icon: Icon(Icons.delete_forever),
                    color: Colors.white,
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: TextButton.icon(
                            onPressed: null,
                            icon: Icon(
                              Icons.warning,
                              color: Colors.red,
                            ),
                            label: Text(
                              "Warning!",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          content: Text(
                            "This will remove all dangling images",
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text("cancal"),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.06,
                                ),
                                RoundedLoadingButton(
                                  height: MediaQuery.of(context).size.height *
                                      0.061,
                                  borderRadius: 3.5,
                                  successColor: Colors.green,
                                  width:
                                      MediaQuery.of(context).size.width * 0.23,
                                  color: Colors.red,
                                  child: Text(
                                    'remove',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  controller: _deleteallController,
                                  onPressed: _deleteprune,
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Imageslist(
            sshclient: sshclient,
          ),
        ],
      ),
    );
  }
}
