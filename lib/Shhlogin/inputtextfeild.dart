import 'package:flutter/material.dart';
import 'package:ssh2/ssh2.dart';

class InputTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController hostController = TextEditingController();
    TextEditingController portController = TextEditingController();
    TextEditingController userController = TextEditingController();
    TextEditingController pasController = TextEditingController();

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
                controller: hostController,
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
                controller: portController,
                textAlign: TextAlign.right,
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
                controller: userController,
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
                controller: pasController,
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
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: 20.0,
                left: 70.0,
              ),
              child: ElevatedButton(
                onPressed: null,
                child: Text("Test"),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 20.0,
                left: 90.0,
              ),
              child: ElevatedButton(
                onPressed: () async {
                  var host = hostController.text;
                  var port = portController.text;
                  var username = userController.text;
                  var password = pasController.text;

                  var client = SSHClient(
                      host: host,
                      port: int.parse(port),
                      username: username,
                      passwordOrKey: password);

                  await client.connect();
                },
                child: Text("Connect"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
