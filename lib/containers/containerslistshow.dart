import 'dart:async';

import 'package:docker_app/Shhlogin/inputtextfeild___ssh-connection.dart';
import 'package:docker_app/containers/commit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ContainersListShow extends StatefulWidget {
  var sshclient;
  ContainersListShow({this.sshclient});

  @override
  _ContainersListShowState createState() => _ContainersListShowState();
}

class _ContainersListShowState extends State<ContainersListShow> {
  List<String> namelist = [];
  List<String> statelist = [];
  List<String> imagelist = [];
  List<String> statuslist = [];

  var conname;
  var constate;
  var conimage;
  var constatus;
  containerlist() async {
    try {
      conname =
          await widget.sshclient.execute("docker ps -a --format '{{.Names}}'");
      namelist = conname.split("\n");

      namelist.remove("");
      constate =
          await widget.sshclient.execute("docker ps -a --format '{{.State}}'");
      statelist = constate.split("\n");
      statelist.remove("");

      conimage =
          await widget.sshclient.execute("docker ps -a --format '{{.Image}}'");
      imagelist = conimage.split("\n");
      imagelist.remove("");
      constatus =
          await widget.sshclient.execute("docker ps -a --format '{{.Status}}'");
      statuslist = constatus.split("\n");
      statuslist.remove("");
      setState(
        () {
          namelist;
          statelist;
          imagelist;
          statuslist;
        },
      );
    } catch (e) {
      try {
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
        await widget.sshclient.connect();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("session connected"),
          ),
        );
      } catch (e) {}
    }
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  void _onRefresh() async {
    await Future.delayed(
      Duration(),
      () async {
        containerlist();
      },
    );

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  final RoundedLoadingButtonController _rmcontainerController =
      RoundedLoadingButtonController();
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: ClassicHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: namelist.isEmpty
            ? Container(
                padding: EdgeInsets.only(top: 40.0),
                alignment: Alignment.topCenter,
                child: Text(
                  "No container(s) found",
                  style: TextStyle(fontSize: 15.0),
                ),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    trailing: statelist[index]
                            .toLowerCase()
                            .contains("exited".toLowerCase())
                        ? PopupMenuButton(
                            itemBuilder: (_) => const <PopupMenuItem<String>>[
                              PopupMenuItem<String>(
                                  child: Text('start'), value: 'start'),
                              PopupMenuItem<String>(
                                  child: Text('remove'), value: 'rm'),
                              PopupMenuItem<String>(
                                  child: Text('commit'), value: 'commit'),
                            ],
                            onSelected: (value) async {
                              void _rmcontainer() async {
                                try {
                                  await widget.sshclient.execute("docker " +
                                      value.toString() +
                                      "\t" +
                                      namelist[index].replaceAll("\r", ""));

                                  _onRefresh();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "container deleted successfully"),
                                    ),
                                  );

                                  _rmcontainerController.success();
                                  Navigator.of(context).pop();
                                } catch (e) {
                                  try {
                                    _rmcontainerController.error();
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

                                    await widget.sshclient.connect();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Connected"),
                                      ),
                                    );
                                  } catch (e) {}
                                }
                              }

                              try {
                                if (value == "rm") {
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
                                        "You are about to delete the ${namelist[index]} containers.Deleted containers will not be recoverable.",
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
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
                                                'remove',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              controller:
                                                  _rmcontainerController,
                                              onPressed: _rmcontainer,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (value == "start") {
                                  await widget.sshclient.execute("docker " +
                                      value.toString() +
                                      "\t" +
                                      namelist[index].replaceAll("\r", ""));

                                  _onRefresh();
                                } else if (value == "commit") {
                                  showDialog(
                                    useRootNavigator: false,
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text(
                                        "Create a new image",
                                        style: TextStyle(
                                          fontSize: 17.0,
                                        ),
                                      ),
                                      content: commitpage(
                                        sshclient: widget.sshclient,
                                        name: namelist[index],
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
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

                                await widget.sshclient.connect();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Connected"),
                                  ),
                                );
                              }
                            },
                          )
                        : PopupMenuButton(
                            itemBuilder: (_) => const <PopupMenuItem<String>>[
                              PopupMenuItem<String>(
                                  child: Text('stop'), value: 'stop'),
                              PopupMenuItem<String>(
                                  child: Text('commit'), value: 'commit'),
                            ],
                            onSelected: (value) async {
                              try {
                                if (value == "stop") {
                                  var result = await widget.sshclient.execute(
                                      "docker " +
                                          value.toString() +
                                          "\t" +
                                          namelist[index].replaceAll("\r", ""));
                                  _onRefresh();
                                } else if (value == "commit") {
                                  showDialog(
                                    useRootNavigator: false,
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text(
                                        "Create a new image",
                                        style: TextStyle(
                                          fontSize: 17.0,
                                        ),
                                      ),
                                      content: commitpage(
                                        sshclient: widget.sshclient,
                                        name: namelist[index],
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
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

                                await widget.sshclient.connect();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Connected"),
                                  ),
                                );
                              }
                            },
                          ),
                    leading: statelist[index]
                            .toLowerCase()
                            .contains("exited".toLowerCase())
                        ? Container(
                            height: 60.0,
                            width: 6.0,
                            color: Colors.red,
                          )
                        : Container(
                            height: 60.0,
                            width: 6.0,
                            color: Colors.green,
                          ),
                    isThreeLine: true,
                    title: Text(
                      namelist[index],
                    ),
                    subtitle: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(statuslist[index]),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            children: [
                              Text(
                                "image name: " + imagelist[index],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ));
                },
                itemCount: namelist.length,
              ),
      ),
    );
  }
}
