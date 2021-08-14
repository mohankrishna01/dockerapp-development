import 'package:flutter/material.dart';

class DashBoxPaused extends StatelessWidget {
  var pausedcontainers;

  DashBoxPaused({this.pausedcontainers});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.03,
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
            Colors.orangeAccent,
            Colors.orange,
            Colors.orangeAccent,
          ],
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 20.0,
          ),
          Text(
            "Paused Containers",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            pausedcontainers,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
