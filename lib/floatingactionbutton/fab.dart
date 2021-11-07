import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
              if (networkdropdownValue == null) {
                String raw = "docker run -dit --network  default $imagename";
                String unRaw = raw.replaceAll('\r', '');
                conresult = await widget.sshclient.execute(unRaw);
              } else if (networkdropdownValue != null) {
                String raw =
                    "docker run -dit --network  $networkdropdownValue $imagename";
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
              if (networkdropdownValue == null) {
                String raw =
                    "docker run -dit --name $containername --network  default $imagename";
                String unRaw = raw.replaceAll('\r', '');
                conresult = await widget.sshclient.execute(unRaw);
              } else if (networkdropdownValue != null) {
                String raw =
                    "docker run -dit --name $containername --network  $networkdropdownValue $imagename";
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

  var networkdropdownValue;
  var containerlist;
  var conlistvalue;
  var netlistvalue;

  List<String> networkresult = [];

  List<String> conlistresult = [];

  var cgroupdriver;

  networkvalue() async {
    cgroupdriver = await widget.sshclient
        .execute("docker network list --format '{{.Name}}'");
    networkresult = cgroupdriver.split("\n");
    networkresult.remove("");
    setState(() {
      netlistvalue = networkresult;
    });
  }

  void initState() {
    super.initState();

    networkvalue();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800.0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Create Container",
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          actions: [
            IconButton(
              iconSize: 25.0,
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
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.035),
                width: MediaQuery.of(context).size.width * 0.88,
                child: ListView(
                  children: [
                    TextField(
                      controller: containernameController,
                      onChanged: (value) {
                        containername = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.028,
                          horizontal: MediaQuery.of(context).size.width * 0.03,
                        ),
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
                        contentPadding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.028,
                          horizontal: MediaQuery.of(context).size.width * 0.03,
                        ),
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
                        contentPadding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.025,
                          horizontal: MediaQuery.of(context).size.width * 0.03,
                        ),
                        labelText: "Network",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      value: networkdropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      onChanged: (String? newValue) {
                        setState(() {
                          networkdropdownValue = newValue!;
                        });

                        print(networkdropdownValue);
                      },
                      items: networkresult.map<DropdownMenuItem<String>>(
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
                    SizedBox(
                      height: 13.0,
                    ),
                    Container(
                      child: RoundedLoadingButton(
                        successColor: Colors.green,
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Text(
                          'create',
                          style: TextStyle(
                            color: Colors.white,
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
      ),
    );
  }
}
