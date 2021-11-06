import 'package:flutter/material.dart';

class DockerInfoBox extends StatelessWidget {
  var nofimages;
  var serverversion;
  var cgroupdriver;
  var kernalversion;
  var operatingsystem;
  var ostype;
  var defaultruntime;
  var registry;
  var productlicense;

  DockerInfoBox({
    this.nofimages,
    this.serverversion,
    this.cgroupdriver,
    this.kernalversion,
    this.operatingsystem,
    this.ostype,
    this.defaultruntime,
    this.registry,
    this.productlicense,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Card(
          elevation: 5.0,
          child: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.012,
              ),
              ListTile(
                leading: Icon(Icons.broken_image),
                title: Text("Images:  " + nofimages),
              ),
              ListTile(
                leading: Icon(Icons.verified),
                title: Text("Server Version:  " + serverversion),
              ),
              ListTile(
                leading: Icon(Icons.group_work),
                title: Text("Cgroup Driver:  " + cgroupdriver),
              ),
              ListTile(
                leading: Icon(Icons.memory_rounded),
                title: Text("Default Runtime: " + defaultruntime),
              ),
              ListTile(
                leading: Icon(Icons.shield_rounded),
                title: Text("Kernel Version: " + kernalversion),
              ),
              ListTile(
                leading: Icon(Icons.laptop_windows),
                title: Text("Operating System: " + operatingsystem),
              ),
              ListTile(
                leading: Icon(Icons.laptop_mac),
                title: Text("OSType: " + ostype),
              ),
              ListTile(
                leading: Icon(Icons.layers_rounded),
                title: Text("Registry: " + registry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
