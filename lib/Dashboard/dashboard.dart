import 'package:flutter/material.dart';

class DashboardUi extends StatefulWidget {
  @override
  _DashboardUiState createState() => _DashboardUiState();
}

class _DashboardUiState extends State<DashboardUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: IconButton(
            alignment: Alignment.bottomLeft,
            icon: Icon(Icons.list_alt),
            onPressed: null,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            onPressed: null,
            child: Icon(
              Icons.add,
              size: 30.0,
            )));
  }
}
