import 'dart:async';

import 'package:docker_app/images/history.dart';
import 'package:docker_app/images/inspect.dart';
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
  List<String> imgtaglist = [];

  var imgn;
  var imgcs;
  var imgtag;

  containerlist() async {
    var imgname;
    var imagecs;
    var imagetag;
    try {
      imgname = await widget.sshclient
          .execute("docker images  --format '{{.Repository}}'");
      imgnamelist = imgname.split("\n");

      imgnamelist.remove("");

      imagecs = await widget.sshclient
          .execute("docker images  --format '{{.CreatedSince}}'");
      imagecslist = imagecs.split("\n");
      imagecslist.remove("");
      imagetag =
          await widget.sshclient.execute("docker images  --format '{{.Tag}}'");
      imgtaglist = imagetag.split("\n");
      imgtaglist.remove("");
      setState(
        () {
          imgn = imgname;
          imgcs = imagecs;
          imgtag = imgtag;
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: ClassicHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
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
                            child: Text('remove'), value: 'rmi'),
                        PopupMenuItem<String>(
                            child: Text('history'), value: 'history'),
                        PopupMenuItem<String>(
                            child: Text('inspect'), value: 'inspect'),
                      ],
                      onSelected: (value) async {
                        try {
                          if (value == "rmi") {
                            var id = await widget.sshclient.execute(
                                "docker images" +
                                    "\t" +
                                    imgnamelist[index].replaceAll("\r", "") +
                                    "\t" +
                                    "-q");
                            var result = await widget.sshclient.execute(
                                "docker rmi" + "\t" + id.replaceAll("\r", ""));

                            _onRefresh();
                            var id2 = await widget.sshclient.execute(
                                "docker images" +
                                    "\t" +
                                    imgnamelist[index].replaceAll("\r", "") +
                                    "\t" +
                                    "-q");
                            id == id2
                                ? ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Image not removed"),
                                    ),
                                  )
                                : ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("Image removed successfully"),
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
                          Text(imgtaglist[index]),
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
