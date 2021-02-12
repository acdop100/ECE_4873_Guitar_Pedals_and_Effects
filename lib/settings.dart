import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _Settings createState() => _Settings();
}

class _Settings extends State<Settings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(color: Color(0xffFFFFFF)),
        ),
        backgroundColor: Color(0xff042082),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(child: Container(),),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: RaisedButton(
              color: Colors.blueGrey[600],
              onPressed: () {
                // Enable effect
              },
              child: Text(
                'Connect to Pedal Board',
                style: TextStyle(color: Color(0xffFFFFFF)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}