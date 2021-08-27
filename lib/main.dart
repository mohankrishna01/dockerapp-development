import 'package:docker_app/Dashboard/dashboard.dart';
import 'package:docker_app/Shhlogin/ShhLoginPage.dart';
import 'package:docker_app/containers/containerlist.dart';
import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "home",
    routes: {
      "home": (context) => ShhLoginPage(),
      "dashboard": (context) => DashboardUi(),
      "containerlist": (context) => ContainerList(),
    },
  ));
}
