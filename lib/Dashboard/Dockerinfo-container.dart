import 'package:docker_app/Dashboard/dashboxTC.dart';
import 'package:flutter/material.dart';

class DockerInfoContainer extends StatefulWidget {
  @override
  _DockerInfoContainerState createState() => _DockerInfoContainerState();
  var sshclient;

  DockerInfoContainer({this.sshclient});
}

class _DockerInfoContainerState extends State<DockerInfoContainer> {
  String totalcontainers = "-";

  void totalcontainervalue(changedvalue) {
    setState(() {
      totalcontainers = changedvalue;
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
              var result = await widget.sshclient
                  .execute("docker info --format '{{json .Containers}}'");
              totalcontainervalue(result);
            },
            icon: Icon(Icons.refresh),
          ),
        ),
        DashBoxTC(
          totalcontainers: totalcontainers,
        ),
      ],
    );
  }
}
