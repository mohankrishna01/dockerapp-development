import 'package:flutter/material.dart';

class DashboardUi extends StatelessWidget {
  var client;
  DashboardUi({this.client});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: IconButton(
            alignment: Alignment.bottomLeft,
            icon: Icon(Icons.list_alt),
            onPressed: null,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var result = await client.execute("ps");
              print(result);
            },
            child: Icon(
              Icons.add,
              size: 30.0,
            )));
  }
}
