import 'package:docker_app/Dashboard/Dockerinfo-container.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'Dockerinfo-container.dart';

class DashboardUi extends StatefulWidget {
  var client;

  DashboardUi({this.client});

  @override
  _DashboardUiState createState() => _DashboardUiState();
}

class _DashboardUiState extends State<DashboardUi> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  var tcresult = "...";
  var rnresult = "...";
  var psresult = "...";
  var stresult = "...";
  void setvalue(
    tcres,
    rnres,
    psres,
    stres,
  ) {
    setState(() {
      tcresult = tcres;
      rnresult = rnres;
      psresult = psres;
      stresult = stres;
    });
  }

  void _onRefresh() async {
    // monitor network fetch

    await Future.delayed(
      Duration(),
      () async {
        try {
          tcresult = await widget.client
              .execute("docker info --format '{{json .Containers}}'");
          rnresult = await widget.client
              .execute("docker info --format '{{json .ContainersRunning}}'");
          psresult = await widget.client
              .execute("docker info --format '{{json .ContainersPaused}}'");
          stresult = await widget.client
              .execute("docker info --format '{{json .ContainersStopped}}'");
          setvalue(tcresult, rnresult, psresult, stresult);
        } catch (e) {
          try {
            widget.client.connect();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("session is down"),
              ),
            );
          } catch (e) {}
        }
      },
    );

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          "Dashboard",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {},
        child: Icon(
          Icons.add,
          size: 30.0,
          color: Colors.blue,
        ),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: ClassicHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DockerInfoContainer(
              sshclient: widget.client,
              totalcontainers: tcresult,
              pausedcontainers: psresult,
              runningcontainers: rnresult,
              stoppedcontainers: stresult,
            ),
          ],
        ),
      ),
    );
  }
}
