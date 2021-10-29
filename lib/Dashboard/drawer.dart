import 'package:docker_app/containers/containerlist.dart';
import 'package:docker_app/images/appbaroption.dart';

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContainerList(
                        sshclient: sshclient,
                      ),
                    ),
                  );
                },
                title: Text("Container(s)"),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Imagesoption(
                        sshclient: sshclient,
                      ),
                    ),
                  );
                },
                title: Text("Image(s)"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
