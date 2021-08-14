import 'package:docker_app/Dashboard/dashboxPs.dart';
import 'package:docker_app/Dashboard/dashboxRunning.dart';
import 'package:docker_app/Dashboard/dashboxTC.dart';
import 'package:docker_app/Dashboard/dashboxst.dart';
import 'package:flutter/material.dart';

class DockerInfoContainer extends StatefulWidget {
  @override
  _DockerInfoContainerState createState() => _DockerInfoContainerState();
  var sshclient;

  DockerInfoContainer({this.sshclient});
}

class _DockerInfoContainerState extends State<DockerInfoContainer> {
  String totalcontainers = "-";
  String runningcontainers = "-";
  String pausedcontainers = "-";
  String stoppedcontainers = "-";

  void totalcontainervalue(
      tcchangedvalue, rnchangedvalue, pschangevalue, stchangevalue) {
    setState(() {
      totalcontainers = tcchangedvalue;
      runningcontainers = rnchangedvalue;
      pausedcontainers = pschangevalue;
      stoppedcontainers = stchangevalue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 350.0),
          child: IconButton(
            onPressed: () async {
              var tcresult = await widget.sshclient
                  .execute("docker info --format '{{json .Containers}}'");
              var rnresult = await widget.sshclient.execute(
                  "docker info --format '{{json .ContainersRunning}}'");
              var psresult = await widget.sshclient
                  .execute("docker info --format '{{json .ContainersPaused}}'");
              var stresult = await widget.sshclient.execute(
                  "docker info --format '{{json .ContainersStopped}}'");
              totalcontainervalue(tcresult, rnresult, psresult, stresult);
            },
            icon: Icon(Icons.refresh),
          ),
        ),
        Row(
          children: [
            DashBoxTC(
              totalcontainers: totalcontainers,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
            ),
            DashBoxRunning(
              runningcontainers: runningcontainers,
            ),
          ],
        ),
        Row(
          children: [
            DashBoxPaused(
              pausedcontainers: pausedcontainers,
            ),
            DashBoxStopped(
              stoppedcontainers: stoppedcontainers,
            ),
          ],
        ),
      ],
    );
  }
}
