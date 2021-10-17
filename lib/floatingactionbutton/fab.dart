import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Fabutton extends StatefulWidget {
  var sshclient;
  Fabutton({this.sshclient});

  @override
  _FabuttonState createState() => _FabuttonState();
}

class _FabuttonState extends State<Fabutton> {
  TextEditingController containernameController = TextEditingController();
  TextEditingController imagenameController = TextEditingController();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  final _formKey = GlobalKey<FormState>();

  var containername;
  var imagename;
  var isloading = false;

  void _doSomething() async {
    Timer(
      Duration(),
      () async {
        if (_formKey.currentState!.validate()) {
          var conresult;

          if (containername == null) {
            try {
              if (dropdownValue == null) {
                String raw = "docker run -dit --network  default $imagename";
                String unRaw = raw.replaceAll('\r', '');
                conresult = await widget.sshclient.execute(unRaw);
              } else if (dropdownValue != null) {
                String raw =
                    "docker run -dit --network  $dropdownValue $imagename";
                String unRaw = raw.replaceAll('\r', '');
                conresult = await widget.sshclient.execute(unRaw);
              }
            } catch (e) {
              _btnController.error();
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(
                    "Error",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  content: Text(
                    "Host is down or No internet",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
              Timer(
                Duration(seconds: 3),
                () {
                  try {
                    _btnController.reset();
                  } catch (e) {}
                },
              );
              try {
                await widget.sshclient.connect();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("session connected"),
                  ),
                );
              } catch (e) {}
            }
          } else if (containername != null) {
            try {
              if (dropdownValue == null) {
                String raw =
                    "docker run -dit --name $containername --network  default $imagename";
                String unRaw = raw.replaceAll('\r', '');
                conresult = await widget.sshclient.execute(unRaw);
              } else if (dropdownValue != null) {
                String raw =
                    "docker run -dit --name $containername --network  $dropdownValue $imagename";
                String unRaw = raw.replaceAll('\r', '');
                conresult = await widget.sshclient.execute(unRaw);
              }
            } catch (e) {
              _btnController.error();
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(
                    "Error",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  content: Text(
                    "Host is down or No internet",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
              Timer(
                Duration(seconds: 3),
                () {
                  try {
                    _btnController.reset();
                  } catch (e) {}
                },
              );
              try {
                await widget.sshclient.connect();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("session connected"),
                  ),
                );
              } catch (e) {}
            }
          }

          if (conresult.hashCode == 1) {
            _btnController.error();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Failed : Not Created"),
              ),
            );
            Timer(
              Duration(seconds: 4),
              () {
                try {
                  _btnController.reset();
                } catch (e) {}
              },
            );
          } else if (conresult.hashCode == 2011) {
          } else {
            _btnController.success();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Container Created Successfully"),
              ),
            );
            Timer(
              Duration(seconds: 3),
              () {
                try {
                  _btnController.reset();
                } catch (e) {}
              },
            );
            containernameController.clear();
            imagenameController.clear();
          }
        } else {
          _btnController.error();

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

          Timer(
            Duration(seconds: 3),
            () {
              try {
                _btnController.reset();
              } catch (e) {}
            },
          );
        }
      },
    );
  }

  var dropdownValue;
  List<String> result = [];
  var cgroupdriver;
  networkvalue() async {
    cgroupdriver = await widget.sshclient
        .execute("docker network list --format '{{.Name}}'");
    result = cgroupdriver.split("\n");
    result.remove("");

    setState(() {
      result;
    });
  }

  void initState() {
    super.initState();
    networkvalue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Container"),
        actions: [
          IconButton(
            iconSize: 28.0,
            onPressed: () {
              setState(() {
                isloading = true;
              });
              networkvalue();

              setState(() {
                isloading = false;
              });
            },
            icon: Icon(Icons.refresh_outlined),
          ),
        ],
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
                  SizedBox(
                    height: 15.0,
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Network",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });

                      print(dropdownValue);
                    },
                    items: result.map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                  ),
                  SizedBox(
                    height: 13.0,
                  ),
                  Container(
                    child: RoundedLoadingButton(
                      successColor: Colors.green,
                      height: 45.0,
                      width: 98.0,
                      child: Text(
                        'create',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.5,
                        ),
                      ),
                      controller: _btnController,
                      onPressed: _doSomething,
                    ),
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
