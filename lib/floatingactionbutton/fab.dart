import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class Fabutton extends StatefulWidget {
  var sshclient;
  Fabutton({this.sshclient});

  @override
  _FabuttonState createState() => _FabuttonState();
}

class _FabuttonState extends State<Fabutton> {
  var isloading = false;
  TextEditingController containernameController = TextEditingController();
  TextEditingController imagenameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var containername;
    var imagename;
    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Container"),
      ),
      body: LoadingOverlay(
        isLoading: isloading,
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              margin: EdgeInsets.only(top: 10.0),
              width: 350.0,
              child: ListView(
                children: [
                  TextField(
                    controller: containernameController,
                    onChanged: (value) {
                      containername = value;
                    },
                    decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    validator: (namecontroller) {
                      if (namecontroller!.isEmpty) {
                        return ('Image name is required');
                      }
                      return null;
                    },
                    controller: imagenameController,
                    onChanged: (value) {
                      imagename = value;
                    },
                    decoration: InputDecoration(
                      labelText: "Image name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  MaterialButton(
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Colors.blue,
                    child: Text(
                      "create",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isloading = true;
                        });
                        var tcresult;
                        if (containername == null) {
                          tcresult = await widget.sshclient
                              .execute("docker run -dit $imagename");
                        } else if (containername != null) {
                          tcresult = await widget.sshclient.execute(
                              "docker run -dit --name $containername $imagename");
                        }

                        if (tcresult.hashCode == 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Failed : Not Created"),
                            ),
                          );
                          setState(() {
                            isloading = false;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Container Created Successfully"),
                            ),
                          );
                          setState(
                            () {
                              isloading = false;
                            },
                          );
                        }
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
                      containernameController.clear();
                      imagenameController.clear();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
