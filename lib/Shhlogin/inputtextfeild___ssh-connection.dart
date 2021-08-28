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
    final _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: [
          Container(
            width: 350,
            child: Column(
              children: [
                TextFormField(
                  validator: (namecontroller) {
                    if (namecontroller!.isEmpty) {
                      return ('Name is required');
                    }
                    return null;
                  },
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
                TextFormField(
                  validator: (namecontroller) {
                    if (namecontroller!.isEmpty) {
                      return ('Host is required');
                    }
                    return null;
                  },
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
                  validator: (namecontroller) {
                    if (namecontroller!.isEmpty) {
                      return ('Port is required');
                    }
                    return null;
                  },
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
                TextFormField(
                  validator: (namecontroller) {
                    if (namecontroller!.isEmpty) {
                      return ('Username is required');
                    }
                    return null;
                  },
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
                TextFormField(
                  validator: (namecontroller) {
                    if (namecontroller!.isEmpty) {
                      return ('Password is required');
                    }
                    return null;
                  },
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
                      if (_formKey.currentState!.validate()) {
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
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red[400],
                            content: Text(
                              "Please complete all required fields",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: Text("Connect"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
