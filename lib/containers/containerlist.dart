import 'package:flutter/material.dart';

class ContainerList extends StatefulWidget {
  var sshclient;
  ContainerList({this.sshclient});
  @override
  _ContainerListState createState() => _ContainerListState();
}

class _ContainerListState extends State<ContainerList> {
  @override
  Widget build(BuildContext context) {
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
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text("cancal"),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.red,
                                ),
                              ),
                              onPressed: () async {
                                await widget.sshclient
                                    .execute("docker rm  \$(docker ps -q -a)");

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text("All stopped containers deleted"),
                                  ),
                                );
                                Navigator.of(ctx).pop();
                              },
                              child: Text(
                                "delete",
                              ),
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
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text("cancal"),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.red,
                                ),
                              ),
                              onPressed: () async {
                                await widget.sshclient.execute(
                                    "docker rm -f \$(docker ps -q -a)");

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("All containers deleted"),
                                  ),
                                );
                                Navigator.of(ctx).pop();
                              },
                              child: Text(
                                "delete all",
                              ),
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
        ],
      ),
    );
  }
}
