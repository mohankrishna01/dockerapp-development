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
        top: MediaQuery.of(context).size.height * 0.04,
        left: MediaQuery.of(context).size.height * 0.03,
      ),
      height: 95.0,
      width: 140.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0), //color: Colors.blue,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.lightBlue,
            Colors.blue,
            Colors.lightBlue,
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(
              bottom: 12.0,
              left: 20.0,
            ),
            child: Icon(
              Icons.check_box_outlined,
              color: Colors.white,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 5.0,
              bottom: 12.0,
            ),
            child: Text(
              "12",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          )
        ],
      ),
    );
  }
}
