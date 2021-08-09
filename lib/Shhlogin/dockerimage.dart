import 'package:flutter/material.dart';

class DockerImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 20.0),
      child: Image.network(
        "https://www.docker.com/sites/default/files/d8/2019-07/vertical-logo-monochromatic.png",
        height: 120.0,
        width: 120.0,
      ),
    );
  }
}
