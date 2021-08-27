import 'package:flutter/material.dart';

class ContainerList extends StatefulWidget {
  var sshclient;
  ContainerList({this.sshclient});
  @override
  _ContainerListState createState() => _ContainerListState();
}

class _ContainerListState extends State<ContainerList> {
  /*
  var tcresult;

  late List containerlist = [];
  clist() async {
    tcresult = await widget.sshclient.execute("docker ps ");

    setState(() {
      tcresult;
    });
    var index = tcresult.length;
    // /print(tcresult);
    containerlist.clear();
    containerlist.add(tcresult);
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Container List"),
        /*actions: [
          IconButton(
            icon: Icon(Icons.ac_unit),
            onPressed: clist,
          )
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (context, int index) {
            return Container(
              child: Card(
                child: ListTile(
                  title: Text(containerlist[index]),
                ),
              ),
            );
          },
          itemCount: containerlist.length,
        ),
        */
      ),
    );
  }
}
