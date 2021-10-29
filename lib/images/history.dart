import 'package:flutter/material.dart';

class Historyimage extends StatefulWidget {
  var sshclient;
  var imageid;
  Historyimage({this.sshclient, this.imageid});

  @override
  _HistoryimageState createState() => _HistoryimageState();
}

class _HistoryimageState extends State<Historyimage> {
  var result;

  history() async {
    try {
      var historyresult = await widget.sshclient.execute(
          "docker image history" + "\t" + widget.imageid.replaceAll("\r", ""));

      setState(() {
        result = historyresult;
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
    history();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
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
                    wordSpacing: 6.0,
                    height: 1.8,
                  ),
                ),
        ],
      ),
    );
  }
}
