import 'package:flutter/material.dart';

class DashboardUi extends StatelessWidget {
  var client;
  DashboardUi({this.client});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dashboard"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var result = await client.execute("ls");
              print(result);
            },
            child: Icon(
              Icons.add,
              size: 30.0,
            )));
  }
}
