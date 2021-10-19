import 'package:flutter/material.dart';

class inspectpage extends StatefulWidget {
  var sshclient;
  var name;
  inspectpage({this.sshclient, this.name});

  @override
  State<inspectpage> createState() => _inspectpageState();
}

class _inspectpageState extends State<inspectpage> {
  var result;

  inspect() async {
    try {
      var inspectresult = await widget.sshclient
          .execute("docker inspect" + "\t" + widget.name.replaceAll("\r", ""));

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
        title: Text("Inspect"),
      ),
      body: ListView(
        children: [
          result == null
              ? Center(
                  child: Container(
                      padding: EdgeInsets.only(top: 100.0),
                      child: Text("No data found")),
                )
              : Text(result)
        ],
      ),
    );
  }
}
