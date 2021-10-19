import 'package:flutter/material.dart';

class logspage extends StatefulWidget {
  var sshclient;
  var name;
  logspage({this.sshclient, this.name});
  @override
  _logspageState createState() => _logspageState();
}

class _logspageState extends State<logspage> {
  var result;

  logs() async {
    try {
      var logsresult = await widget.sshclient
          .execute("docker logs" + "\t" + widget.name.replaceAll("\r", ""));

      setState(() {
        result = logsresult;
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
    logs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Logs"),
        ),
        body: ListView(
          children: [
            result.hashCode == 1
                ? Center(
                    child: Container(
                        padding: EdgeInsets.only(top: 100.0),
                        child: Text("No logs")),
                  )
                : result == null
                    ? Center(
                        child: Container(
                            padding: EdgeInsets.only(top: 100.0),
                            child: Text("No data found")),
                      )
                    : Text(
                        result,
                        style: TextStyle(
                          fontSize: 15.0,
                          wordSpacing: 5.0,
                        ),
                      ),
          ],
        ));
  }
}
