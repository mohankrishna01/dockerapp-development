import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
      widget.sshclient.connect();
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
    }
  }

  void initState() {
    super.initState();
    containerlist();
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: ClassicHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
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
              ),
            );
          },
          itemCount: namelist.length,
        ),
      ),
    );
  }
}
