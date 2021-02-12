import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Pedal Effects",
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
                    'Activate Pedal Board',
                    style: TextStyle(color: Color(0xffFFFFFF)),
                  ),
                ),
              ),
            ],
          ),
      );
    }
  }