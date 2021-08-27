import 'package:docker_app/containers/containerlist.dart';
import 'package:flutter/material.dart';

class DashboardDrawer extends StatelessWidget {
  var sshclient;
  var name;
  DashboardDrawer({this.sshclient, this.name});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
          child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(sshclient.host),
          ),
          Card(
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(context, "containerlist");
              },
              enableFeedback: true,
              title: Text("Containers"),
            ),
          )
        ],
      )),
    );
  }
}
