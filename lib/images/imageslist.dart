import 'dart:async';

import 'package:docker_app/images/history.dart';
import 'package:docker_app/images/inspect.dart';
import 'package:docker_app/images/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Imageslist extends StatefulWidget {
  var sshclient;

  Imageslist({this.sshclient});

  @override
  _ImageslistState createState() => _ImageslistState();
}

class _ImageslistState extends State<Imageslist> {
  List<String> imgnamelist = [];

  List<String> imagecslist = [];

  imagelist() async {
    var imgname;
    var imagecs;

    try {
      imgname = await widget.sshclient
          .execute("docker images  --format '{{.Repository}}:{{.Tag}}'");
      imgnamelist = imgname.split("\n");

      imgnamelist.remove("");

      imagecs = await widget.sshclient
          .execute("docker images --format '{{.CreatedSince}}'");
      imagecslist = imagecs.split("\n");
      imagecslist.remove("");

      setState(
        () {
          imgname;
          imagecs;
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

  void onRefresh() async {
    await Future.delayed(
      Duration(),
      () async {
        imagelist();
      },
    );

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  final RoundedLoadingButtonController _removeimageController =
      RoundedLoadingButtonController();

  void _removeimage(index) async {}

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: ClassicHeader(),
        controller: _refreshController,
        onRefresh: onRefresh,
        child: imgnamelist.isEmpty
            ? Container(
                padding: EdgeInsets.only(top: 40.0),
                alignment: Alignment.topCenter,
                child: Text(
                  "No image(s) found",
                  style: TextStyle(fontSize: 15.0),
                ),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    trailing: PopupMenuButton(
                      itemBuilder: (_) => const <PopupMenuItem<String>>[
                        PopupMenuItem<String>(
                          child: Text('history'),
                          value: 'history',
                        ),
                        PopupMenuItem<String>(
                          child: Text('inspect'),
                          value: 'inspect',
                        ),
                        PopupMenuItem<String>(
                          child: Text('remove'),
                          value: 'rmi',
                        ),
                        PopupMenuItem<String>(
                          child: Text('tag'),
                          value: 'tag',
                        ),
                      ],
                      onSelected: (value) async {
                        try {
                          if (value == "rmi") {
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
                                  "You are about to delete the image.\nDeleted image will not be recoverable.\n\nNote: if the image is used by the container you're not able to delete image.",
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
                                          'remove',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        controller: _removeimageController,
                                        onPressed: () async {
                                          try {
                                            var remove = await widget.sshclient
                                                .execute(
                                                    "docker rmi ${imgnamelist[index].replaceAll("\r", "")}");
                                            onRefresh();

                                            if (remove.hashCode == 1) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content:
                                                      Text("Image not removed"),
                                                ),
                                              );
                                              _removeimageController.error();
                                              Timer(
                                                  Duration(milliseconds: 1300),
                                                  () {
                                                try {
                                                  _removeimageController
                                                      .reset();
                                                  Navigator.of(context).pop();
                                                } catch (e) {}
                                              });
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "Image removed successfully"),
                                                ),
                                              );
                                              _removeimageController.success();
                                              Timer(
                                                  Duration(milliseconds: 1000),
                                                  () {
                                                try {
                                                  _removeimageController
                                                      .reset();
                                                } catch (e) {}

                                                Navigator.of(context).pop();
                                              });
                                            }
                                          } catch (e) {
                                            try {
                                              _removeimageController.error();
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
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text("Connected"),
                                                ),
                                              );
                                            } catch (e) {}
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          } else if (value == "history") {
                            var id = await widget.sshclient.execute(
                                "docker images" +
                                    "\t" +
                                    imgnamelist[index].replaceAll("\r", "") +
                                    "\t" +
                                    "-q");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Historyimage(
                                  sshclient: widget.sshclient,
                                  imageid: id,
                                ),
                              ),
                            );
                          } else if (value == "inspect") {
                            var id = await widget.sshclient.execute(
                                "docker images" +
                                    "\t" +
                                    imgnamelist[index].replaceAll("\r", "") +
                                    "\t" +
                                    "-q");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Imageinspect(
                                  sshclient: widget.sshclient,
                                  imageid: id,
                                ),
                              ),
                            );
                          } else if (value == "tag") {
                            showDialog(
                              useRootNavigator: false,
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text(
                                  "Change image name",
                                  style: TextStyle(
                                    fontSize: 17.0,
                                  ),
                                ),
                                content: Imagetag(
                                  sshclient: widget.sshclient,
                                  imagenameid: imgnamelist[index],
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
                    leading: Container(
                      height: 60.0,
                      width: 6.0,
                      color: Colors.green,
                    ),
                    isThreeLine: true,
                    title: Text(
                      imgnamelist[index],
                    ),
                    subtitle: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(""),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            children: [
                              Text(
                                "CreatedSince: " + imagecslist[index],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ));
                },
                itemCount: imgnamelist.length,
              ),
      ),
    );
  }
}
