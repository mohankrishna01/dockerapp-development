import 'package:flutter/material.dart';

class DockerImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Image.asset(
        "lib/icons/horizontal-logo-monochromatic-white.png",
        height: MediaQuery.of(context).size.height * 0.19,
        width: MediaQuery.of(context).size.height * 0.27,
      ),
    );
  }
}
