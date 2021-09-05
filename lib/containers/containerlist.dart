import 'dart:async';

import 'package:docker_app/containers/containerslistshow.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ContainerList extends StatelessWidget {
  var sshclient;
  ContainerList({this.sshclient});

  @override
  Widget build(BuildContext context) {
    final RoundedLoadingButtonController _deleteallController =
        RoundedLoadingButtonController();
    final RoundedLoadingButtonController _deleteallstController =
        RoundedLoadingButtonController();

    void _deleteall() async {
      Timer(Duration(), () async {
        await sshclient.execute("docker rm -f \$(docker ps -q -a)");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("All containers deleted"),
          ),
        );

        _deleteallController.success();
        Timer(Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
      });
    }

    void _deleteallst() async {
      Timer(Duration(), () async {
        await sshclient.execute("docker rm  \$(docker ps -q -a)");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("All stopped containers deleted"),
          ),
        );

        _deleteallstController.success();
        Timer(Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          "Container List",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(
                top: 5.0,
              ),
              height: 50.0,
              width: MediaQuery.of(context).size.width * 0.95,
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    iconSize: 30.0,
                    icon: Icon(
                      Icons.delete_sweep_outlined,
                    ),
                    color: Colors.white,
                    onPressed: () {
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
                              "Warning",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          content: Text(
                            "You are about to delete all stopped containers.Deleted containers will not be recoverable.",
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
                                  width: 20.0,
                                ),
                                RoundedLoadingButton(
                                  height: 37.5,
                                  borderRadius: 3.5,
                                  successColor: Colors.green,
                                  width: 90.0,
                                  color: Colors.red,
                                  child: Text(
                                    'delete all',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  controller: _deleteallstController,
                                  onPressed: _deleteallst,
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  IconButton(
                    iconSize: 28.0,
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
                              "Warning",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          content: Text(
                            "You are about to delete all containers (both stopped and running)     Deleted containers will not be recoverable",
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
                                  width: 20.0,
                                ),
                                RoundedLoadingButton(
                                  height: 37.5,
                                  borderRadius: 3.5,
                                  successColor: Colors.green,
                                  width: 90.0,
                                  color: Colors.red,
                                  child: Text(
                                    'delete all',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  controller: _deleteallController,
                                  onPressed: _deleteall,
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
          ContainersListShow(
            sshclient: sshclient,
          ),
        ],
      ),
    );
  }
}
