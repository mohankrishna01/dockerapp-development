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
                    print(containername);
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
                TextField(
                  controller: imagenameController,
                  onChanged: (value) {
                    imagename = value;
                    print(imagename);
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
                    setState(() {
                      isloading = true;
                    });
                    print("clicked");
                    var tcresult = await widget.sshclient.execute(
                        "docker run -dit --name $containername $imagename");

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
                      setState(() {
                        isloading = false;
                      });
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
    );
  }
}
