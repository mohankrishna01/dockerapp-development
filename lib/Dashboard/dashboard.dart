import 'package:docker_app/Dashboard/Dockerinfo-container.dart';
import 'package:docker_app/Dashboard/dashboard-dockerinfobox.dart';
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
  var nofimages = "...";
  var serverversion = "...";
  var cgroupdriver = "...";
  var kernelversion = "...";
  var operatingsystem = "...";
  var ostype = "...";
  var defaultruntime = "...";
  void setvalue({
    tcres,
    rnres,
    psres,
    stres,
    nimage,
    serversion,
    cgdriver,
    kversion,
    osystem,
    otype,
    druntime,
  }) {
    setState(() {
      tcresult = tcres;
      rnresult = rnres;
      psresult = psres;
      stresult = stres;
      nofimages = nimage;
      serverversion = serversion;
      cgroupdriver = cgdriver;
      kernelversion = kversion;
      operatingsystem = osystem;
      ostype = otype;
      defaultruntime = druntime;
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
          nofimages = await widget.client
              .execute("docker info --format '{{json .Images}}'");
          serverversion = await widget.client
              .execute("docker info --format '{{json .ServerVersion}}'");
          cgroupdriver = await widget.client
              .execute("docker info --format '{{json .CgroupDriver}}'");
          kernelversion = await widget.client
              .execute("docker info --format '{{json .KernelVersion}}'");
          operatingsystem = await widget.client
              .execute("docker info --format '{{json .OperatingSystem}}'");
          ostype = await widget.client
              .execute("docker info --format '{{json .OSType}}'");
          defaultruntime = await widget.client
              .execute("docker info --format '{{json .DefaultRuntime}}'");

          setvalue(
            tcres: tcresult,
            rnres: rnresult,
            psres: psresult,
            stres: stresult,
            nimage: nofimages,
            serversion: serverversion,
            cgdriver: cgroupdriver,
            kversion: kernelversion,
            osystem: operatingsystem,
            otype: ostype,
            druntime: defaultruntime,
          );
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
      drawer: Drawer(
        child: Container(
          color: Colors.amber,
          child: Text("hi"),
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        //automaticallyImplyLeading: false,
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
            SizedBox(
              height: 25.0,
            ),
            Center(
              child: Container(
                height: 30.0,
                width: 160.0,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Center(
                  child: Text(
                    "Docker Info",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            DockerInfoBox(
              nofimages: nofimages,
              serverversion: serverversion,
              cgroupdriver: cgroupdriver,
              kernalversion: kernelversion,
              operatingsystem: operatingsystem,
              ostype: ostype,
              defaultruntime: defaultruntime,
            ),
          ],
        ),
      ),
    );
  }
}
