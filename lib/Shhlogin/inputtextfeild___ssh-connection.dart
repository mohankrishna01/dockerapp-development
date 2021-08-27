import 'package:docker_app/Dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ssh2/ssh2.dart';

class InputTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController hostController = TextEditingController();
    TextEditingController portController = TextEditingController(text: "22");
    TextEditingController userController = TextEditingController();
    TextEditingController pasController = TextEditingController();

    return Column(
      children: [
        Container(
          width: 350,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
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
              TextFormField(
                keyboardType: TextInputType.number,
                controller: portController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
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
                obscureText: true,
                controller: pasController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 20.0,
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    bool errorshow = false;
                    var connectionresult;

                    var host = hostController.text;
                    var port = portController.text;
                    var username = userController.text;
                    var password = pasController.text;
                    var name = nameController.text;
                    var client = SSHClient(
                        host: host,
                        port: int.parse(port),
                        username: username,
                        passwordOrKey: password);

                    try {
                      await client.connect();
                    } on PlatformException catch (e) {
                      connectionresult = e.code;
                      print(connectionresult);
                      var val = connectionresult;
                      errorshow = val.toLowerCase() == 'connection_failure';
                    }

                    errorshow
                        ? ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Authentication failed"),
                            ),
                          )
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DashboardUi(
                                client: client,
                                name: name,
                              ),
                            ),
                          );

                    errorshow
                        ? Null
                        : ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Session connected"),
                            ),
                          );
                  },
                  child: Text("Connect"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
