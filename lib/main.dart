import 'package:docker_app/Shhlogin/ShhLoginPage.dart';
import 'package:flutter/material.dart';

main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "home",
      routes: {
        "home": (context) => ShhLoginPage(),
      },
    ),
  );
}
