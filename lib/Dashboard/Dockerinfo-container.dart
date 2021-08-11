import 'package:flutter/material.dart';

class DockerInfoContainer extends StatefulWidget {
  var client;
  DockerInfoContainer({this.client});
  @override
  _DockerInfoContainerState createState() => _DockerInfoContainerState();
}

class _DockerInfoContainerState extends State<DockerInfoContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 30.0,
        left: 30.0,
      ),
      height: 150.0,
      width: 150.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green, Colors.blue],
        ),
      ),
    );
  }
}
