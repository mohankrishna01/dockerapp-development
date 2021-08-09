import 'package:docker_app/ssh/sshlogin.dart';
import 'package:flutter/material.dart';
import 'package:ssh2/ssh2.dart';

class InputTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 350.0,
          child: Column(
            children: [
              TextField(
                onChanged: (value) {},
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextField(
                onChanged: (value) {
                  sshshare(host: value);
                },
                decoration: InputDecoration(
                  labelText: "Host",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextField(
                textAlign: TextAlign.right,
                onChanged: (value) {
                  sshshare(port: value);
                },
                decoration: InputDecoration(
                  counterText: "22",
                  labelText: "Port",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextField(
                onChanged: (value) {
                  sshshare(username: value);
                },
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextField(
                onChanged: (value) {
                  sshshare(password: value);
                },
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
