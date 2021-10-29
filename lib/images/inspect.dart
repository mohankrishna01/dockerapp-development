import 'package:flutter/material.dart';

class Imageinspect extends StatefulWidget {
  var sshclient;
  var imageid;
  Imageinspect({this.sshclient, this.imageid});

  @override
  State<Imageinspect> createState() => _ImageinspectState();
}

class _ImageinspectState extends State<Imageinspect> {
  var result;

  inspect() async {
    try {
      var inspectresult = await widget.sshclient.execute(
          "docker image inspect" + "\t" + widget.imageid.replaceAll("\r", ""));

      setState(() {
        result = inspectresult;
      });
    } catch (e) {
      try {
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
        await widget.sshclient.connect();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("session connected"),
          ),
        );
      } catch (e) {}
    }
  }

  void initState() {
    super.initState();
    inspect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Inspect"),
      ),
      body: ListView(
        children: [
          result == null
              ? Center(
                  child: Container(
                      padding: EdgeInsets.only(top: 100.0),
                      child: Text("No data found")),
                )
              : Text(
                  result,
                  style: TextStyle(
                    wordSpacing: 1.0,
                    height: 1.7,
                  ),
                ),
        ],
      ),
    );
  }
}
