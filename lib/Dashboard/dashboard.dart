import 'package:docker_app/Dashboard/Dockerinfo-container.dart';
import 'package:flutter/material.dart';
import 'Dockerinfo-container.dart';

class DashboardUi extends StatelessWidget {
  var client;

  DashboardUi({this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          "Dashboard",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {},
        child: Icon(
          Icons.add,
          size: 30.0,
          color: Colors.blue,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DockerInfoContainer(
            sshclient: client,
          ),
        ],
      ),
    );
  }
}
