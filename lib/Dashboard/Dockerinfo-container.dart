import 'package:docker_app/Dashboard/dashboxPs.dart';
import 'package:docker_app/Dashboard/dashboxRunning.dart';
import 'package:docker_app/Dashboard/dashboxTC.dart';
import 'package:docker_app/Dashboard/dashboxst.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DockerInfoContainer extends StatefulWidget {
  @override
  _DockerInfoContainerState createState() => _DockerInfoContainerState();
  var sshclient;
  String totalcontainers;
  String runningcontainers;
  String pausedcontainers;
  String stoppedcontainers;
  DockerInfoContainer(
      {this.sshclient,
      required this.pausedcontainers,
      required this.runningcontainers,
      required this.stoppedcontainers,
      required this.totalcontainers});
}

class _DockerInfoContainerState extends State<DockerInfoContainer> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.028,
        ),
        Row(
          children: [
            DashBoxTC(
              totalcontainers: widget.totalcontainers,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
            ),
            DashBoxRunning(
              runningcontainers: widget.runningcontainers,
            ),
          ],
        ),
        Row(
          children: [
            DashBoxPaused(
              pausedcontainers: widget.pausedcontainers,
            ),
            DashBoxStopped(
              stoppedcontainers: widget.stoppedcontainers,
            ),
          ],
        ),
      ],
    );
  }
}
