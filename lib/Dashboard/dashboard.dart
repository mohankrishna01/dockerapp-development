import 'package:docker_app/Dashboard/Dockerinfo-container.dart';
import 'package:docker_app/Dashboard/dashboard-dockerinfobox.dart';
import 'package:docker_app/Dashboard/drawer.dart';
import 'package:docker_app/Shhlogin/ShhLoginPage.dart';
import 'package:docker_app/floatingactionbutton/fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'Dockerinfo-container.dart';

class DashboardUi extends StatefulWidget {
  var client;
  var name;

  DashboardUi({
    this.client,
    this.name,
  });

  @override
  _DashboardUiState createState() => _DashboardUiState();
}

class _DashboardUiState extends State<DashboardUi> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

//variables
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
  var registry = "...";
  var productlicense = "...";

  // set state
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
    rg,
    plicense,
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
      registry = rg;
      productlicense = plicense;
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
          registry = await widget.client
              .execute("docker info --format '{{json .IndexServerAddress}}'");

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
            rg: registry,
            plicense: productlicense,
          );
        } catch (e) {
          try {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("session is down"),
              ),
            );
            //reconnect shhclient
            await widget.client.connect();

            //show snack bar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("session connected"),
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
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: DashboardDrawer(
          sshclient: widget.client,
          name: widget.name,
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          shadowColor: Colors.white,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await widget.client.disconnect();

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SshLoginPage()),
                );
              },
            ),
          ],
          title: Text(
            "Dashboard",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) => Fabutton(
                sshclient: widget.client,
              ),
              isScrollControlled: true,
            );
          },
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
                height: MediaQuery.of(context).size.height * 0.023,
              ),
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.055,
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Center(
                    child: Text(
                      "Docker Info",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              DockerInfoBox(
                nofimages: nofimages,
                serverversion: serverversion,
                cgroupdriver: cgroupdriver,
                kernalversion: kernelversion,
                operatingsystem: operatingsystem,
                ostype: ostype,
                defaultruntime: defaultruntime,
                registry: registry,
                productlicense: productlicense,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
