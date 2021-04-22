//import 'dart:html';
import 'package:flutter/material.dart';
import 'patchData.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:convert';


BluetoothConnection connection;

List<Effect> effects = [flangerEff, distortionEff, reverbEff];

Effect flangerEff = Effect(id: 0, name: 'Flanger', desc: "Offset, Depth, Freq Modulation", enabled: 0, effectValue: [30, 30, 30]);

Effect distortionEff = Effect(id: 1, name: 'Distortion', desc: "Gain", enabled: 0, effectValue: [30, 30, 30]);

Effect reverbEff = Effect(id: 2, name: 'Reverb', desc: "Dry, Wet, Roomsize, Damp", enabled: 0, effectValue: [30, 30, 30, 30]);

TextEditingController _effectName = TextEditingController();
String codeDialog;
String valueText;


// Show effect parameters that can be changed
class EffectSettings1 extends StatefulWidget {
  final String recordObject;
  List<int> value = [30, 30, 30];
  EffectSettings1(this.recordObject, this.value);

  @override
  _EffectSettings1 createState() => new _EffectSettings1();
}

class _EffectSettings1 extends State<EffectSettings1> {
  //static const double minValue = 0;
  //static const double maxValue = 10;

  void _setValue(int value, int index) => setState(() => widget.value[index] = value);

  @override
  Widget build(BuildContext context) {
    // New window
    return AlertDialog(
      title: new Text('${widget.recordObject} Settings'),
      actions: <Widget>[
        SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text(
          '${widget.recordObject} Power: ${widget.value[0].toStringAsFixed(1)}',
          textAlign: TextAlign.center,
        ),
        // Effect intensity value
        ButtonBar(
          alignment:MainAxisAlignment.center,
          mainAxisSize:MainAxisSize.max,
          children: [
            FlatButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text('Decrease'),
              onPressed: () {
                if (widget.value[0] > 0)
                {
                  _sendMessage('1');
                  _sendMessage('m');

                  widget.value[0] = widget.value[0] - 5;
                  _setValue(widget.value[0], 0);
                }
              },
            ),
            FlatButton(
              color: Colors.green,
              textColor: Colors.white,
              child: Text('Increase'),
              onPressed: () {
                if (widget.value[0] < 100)
                {
                  _sendMessage('1');
                  _sendMessage('p');

                  widget.value[0] = widget.value[0] + 5;
                  _setValue(widget.value[0], 0);
                }
              },
            ),
          ],
        ),
        Text(
          '${widget.recordObject} Depth: ${widget.value[1].toStringAsFixed(1)}',
          textAlign: TextAlign.center,
        ),
        ButtonBar(
          alignment:MainAxisAlignment.center,
mainAxisSize:MainAxisSize.max,
          children: [
            FlatButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text('Decrease'),
              onPressed: () {
                if (widget.value[1] > 0)
                {
                  _sendMessage('2');
                  _sendMessage('m');

                  widget.value[1] = widget.value[1] - 5;
                  _setValue(widget.value[1], 1);
                }
              },
            ),
            FlatButton(
              color: Colors.green,
              textColor: Colors.white,
              child: Text('Increase'),
              onPressed: () {
                if (widget.value[1] < 100)
                {
                  _sendMessage('2');
                  _sendMessage('p');

                  widget.value[1] = widget.value[1] + 5;
                  _setValue(widget.value[1], 1);
                }
              },
            ),
          ],
        ),
        new Text(
          '${widget.recordObject} Frequency Modulation: ${widget.value[2].toStringAsFixed(1)}',
          textAlign: TextAlign.center,
        ),
        ButtonBar(
          alignment:MainAxisAlignment.center,
mainAxisSize:MainAxisSize.max,
          children: [
            FlatButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text('Decrease'),
              onPressed: () {
                if (widget.value[2] > 0)
                {
                  _sendMessage('3');
                  _sendMessage('m');
                  _sendMessage('z');
                  widget.value[2] = widget.value[2] - 5;
                  _setValue(widget.value[2], 2);
                }
              },
            ),
            FlatButton(
              color: Colors.green,
              textColor: Colors.white,
              child: Text('Increase'),
              onPressed: () {
                if (widget.value[2] < 100)
                {
                  _sendMessage('3');
                  _sendMessage('p');
                  _sendMessage('z');
                  widget.value[2] = widget.value[2] + 5;
                  _setValue(widget.value[2], 2);
                }
              },
            ),
          ],
        ),
        ButtonBar(
          alignment:MainAxisAlignment.center,
          mainAxisSize:MainAxisSize.max,
          children: [
            FlatButton(
              color: Color(0xff042082),
              textColor: Colors.white,
              child: Text('Apply'),
              onPressed: () {
                _sendMessage('x');
                Navigator.pop(context, widget.value);
              },
            ),
          ],
        )]))
      ],
    );
  }
}

class EffectSettings2 extends StatefulWidget {
  final String recordObject;
  List<int> value = [30];
  EffectSettings2(this.recordObject, this.value);

  @override
  _EffectSettings2 createState() => new _EffectSettings2();
}

class _EffectSettings2 extends State<EffectSettings2> {
  //static const double minValue = 0;
  //static const double maxValue = 10;

  void _setValue(int value) => setState(() => widget.value[0] = value);

  @override
  Widget build(BuildContext context) {
    // New window
    return AlertDialog(
      title: new Text('${widget.recordObject} Settings'),
      actions: <Widget>[
    SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
        // Effect intensity value
      new Text(
        '${widget.recordObject} Amp Gain: ${widget.value[0].toStringAsFixed(1)}',
      ),
        ButtonBar(
          alignment:MainAxisAlignment.center,
          mainAxisSize:MainAxisSize.max,
          children: [
            FlatButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text('Decrease'),
              onPressed: () {
                if (widget.value[0] > 0)
                {
                  _sendMessage('m');
                  widget.value[0] = widget.value[0] - 5;
                  _setValue(widget.value[0]);
                }
              },
            ),
            FlatButton(
              color: Colors.green,
              textColor: Colors.white,
              child: Text('Increase'),
              onPressed: () {
                if (widget.value[0] < 100)
                {
                  _sendMessage('p');
                  widget.value[0] = widget.value[0] + 5;
                  _setValue(widget.value[0]);
                }
              },
            ),
            FlatButton(
              color: Color(0xff042082),
              textColor: Colors.white,
              child: Text('Apply'),
              onPressed: () {
                _sendMessage('z');
                _sendMessage('x');
                Navigator.pop(context, widget.value);
              },
            ),
          ],
        )]))
      ],
    );
  }
}

class EffectSettings3 extends StatefulWidget {
  final String recordObject;
  List<int> value = [30, 30, 30, 30];
  EffectSettings3(this.recordObject, this.value);

  @override
  _EffectSettings3 createState() => new _EffectSettings3();
}

class _EffectSettings3 extends State<EffectSettings3> {
  //static const double minValue = 0;
  //static const double maxValue = 10;

  void _setValue(int value, int index) => setState(() => widget.value[index] = value);

  @override
  Widget build(BuildContext context) {
    // New window
    return AlertDialog(
      title: new Text('${widget.recordObject} Settings'),
      actions: <Widget>[
    SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
        new Text(
          '${widget.recordObject} Dryness: ${widget.value[0].toStringAsFixed(1)}',
        ),
        // Effect intensity value
        ButtonBar(
          alignment:MainAxisAlignment.center,
          mainAxisSize:MainAxisSize.max,
          children: [
            FlatButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text('Decrease'),
              onPressed: () {
                if (widget.value[0] > 0)
                {
                  _sendMessage('1');
                  _sendMessage('m');
                  _sendMessage('z');
                  widget.value[0] = widget.value[0] - 5;
                  _setValue(widget.value[0], 0);
                }
              },
            ),
            FlatButton(
              color: Colors.green,
              textColor: Colors.white,
              child: Text('Increase'),
              onPressed: () {
                if (widget.value[0] < 100)
                {
                  _sendMessage('1');
                  _sendMessage('p');
                  _sendMessage('z');
                  widget.value[0] = widget.value[0] + 5;
                  _setValue(widget.value[0], 0);
                }
              },
            ),
          ],
        ),
        new Text(
          '${widget.recordObject} Wetness: ${widget.value[1].toStringAsFixed(1)}',
        ),
        ButtonBar(
          alignment:MainAxisAlignment.center,
          mainAxisSize:MainAxisSize.max,
          children: [
            FlatButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text('Decrease'),
              onPressed: () {
                if (widget.value[1] > 0)
                {
                  _sendMessage('2');
                  _sendMessage('m');
                  _sendMessage('z');
                  widget.value[1] = widget.value[1] - 5;
                  _setValue(widget.value[1], 1);
                }
              },
            ),
            FlatButton(
              color: Colors.green,
              textColor: Colors.white,
              child: Text('Increase'),
              onPressed: () {
                if (widget.value[1] < 100)
                {
                  _sendMessage('2');
                  _sendMessage('p');
                  _sendMessage('z');
                  widget.value[1] = widget.value[1] + 5;
                  _setValue(widget.value[1], 1);
                }
              },
            ),
          ],
        ),
        new Text(
          '${widget.recordObject} Roomsize: ${widget.value[2].toStringAsFixed(1)}',
        ),
        ButtonBar(
          alignment:MainAxisAlignment.center,
          mainAxisSize:MainAxisSize.max,
          children: [
            FlatButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text('Decrease'),
              onPressed: () {
                if (widget.value[2] > 0)
                {
                  _sendMessage('3');
                  _sendMessage('m');
                  _sendMessage('z');
                  widget.value[2] = widget.value[2] - 5;
                  _setValue(widget.value[2], 2);
                }
              },
            ),
            FlatButton(
              color: Colors.green,
              textColor: Colors.white,
              child: Text('Increase'),
              onPressed: () {
                if (widget.value[2] < 100)
                {
                  _sendMessage('3');
                  _sendMessage('p');
                  _sendMessage('z');
                  widget.value[2] = widget.value[2] + 5;
                  _setValue(widget.value[2], 2);
                }
              },
            ),
          ],
        ),
        new Text(
          '${widget.recordObject} Damping: ${widget.value[3].toStringAsFixed(1)}',
        ),
        ButtonBar(
          alignment:MainAxisAlignment.center,
          mainAxisSize:MainAxisSize.max,
          children: [
            FlatButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text('Decrease'),
              onPressed: () {
                if (widget.value[3] > 0)
                {
                  _sendMessage('4');
                  _sendMessage('m');
                  _sendMessage('z');
                  widget.value[3] = widget.value[3] - 5;
                  _setValue(widget.value[3], 3);
                }
              },
            ),
            FlatButton(
              color: Colors.green,
              textColor: Colors.white,
              child: Text('Increase'),
              onPressed: () {
                if (widget.value[3] < 100)
                {
                  _sendMessage('4');
                  _sendMessage('p');
                  _sendMessage('z');
                  widget.value[3] = widget.value[3] + 5;
                  _setValue(widget.value[3], 3);
                }
              },
            ),
          ],
        ),
        ButtonBar(
          alignment:MainAxisAlignment.center,
          mainAxisSize:MainAxisSize.max,
          children: [
            FlatButton(
              color: Color(0xff042082),
              textColor: Colors.white,
              child: Text('Apply'),
              onPressed: () {
                _sendMessage('x');
                Navigator.pop(context, widget.value);
              },
            ),
          ],
        )]))
      ],
    );
  }
}

// For saving effect patches
_saveEffect(BuildContext context) {
  showDialog(
      context: context,
      builder: (_) => new AlertDialog(
            title: new Text("Save Effect"),
            content: TextField(
              onChanged: (value) {},
              controller: _effectName,
              decoration: InputDecoration(hintText: "Choose which state to overwrite"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Color(0xff042082),
                textColor: Colors.white,
                child: Text('1'),
                onPressed: () {
                  Navigator.pop(context);
                  _sendMessage('4');
                  _sendMessage('1');
                },
              ),
              FlatButton(
                color: Color(0xff042082),
                textColor: Colors.white,
                child: Text('2'),
                onPressed: () {
                  Navigator.pop(context);
                  _sendMessage('4');
                  _sendMessage('2');
                },
              ),
              FlatButton(
                color: Color(0xff042082),
                textColor: Colors.white,
                child: Text('3'),
                onPressed: () {
                  Navigator.pop(context);
                  _sendMessage('4');
                  _sendMessage('3');
                },
              ),
            ],
          ));
}

class ListViewCard extends StatefulWidget {
  final int index;
  final Key key;
  final List<Effect> listItems;

  ListViewCard(this.listItems, this.index, this.key);

  @override
  _ListViewCard createState() => _ListViewCard();

}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

// Builds the effect rows
class _ListViewCard extends State<ListViewCard> {
  List<_Message> messages = List<_Message>();
  //String _messageBuffer = '';
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(4),
      color: Colors.white,
      child: InkWell(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Tap dots to edit effect
            new GestureDetector(
              onTap: () {
                // Tell board we are about to edit the parameter
                _sendMessage('3');
                _sendMessage((widget.index + 1).toString());
                // Bring up settings page for that effect
                showDialog(
                    context: context,
                    builder: (_) {
                      if (widget.index == 0)
                      {
                        return EffectSettings1(widget.listItems[widget.index].name,
                            widget.listItems[widget.index].effectValue);
                      } else if (widget.index == 1){
                        _sendMessage('1');
                        return EffectSettings2(widget.listItems[widget.index].name,
                            widget.listItems[widget.index].effectValue);
                      } else {
                      return EffectSettings3(widget.listItems[widget.index].name,
                      widget.listItems[widget.index].effectValue);
                      }
                    }).then((value) {
                  if (value != null) {
                    // Assign value back to structure
                    widget.listItems[widget.index].effectValue = value;
                  }
                });
              },
              child: new Container(
                margin: const EdgeInsets.all(10.0),
                child: Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                  size: 24.0,
                ),
              ),
            ),
            // Title and subtitles (same for now)
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.topLeft,
                    child: Text(
                      '${widget.listItems[widget.index].name}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.left,
                      maxLines: 5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.topLeft,
                    child: Text(
                      '${widget.listItems[widget.index].desc}',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16),
                      textAlign: TextAlign.left,
                      maxLines: 5,
                    ),
                  ),
                ],
              ),
            ),
            // Tap check box to enable the effect
            new GestureDetector(
              onTap: () {
                setState(() {
                  if (widget.listItems[widget.index].enabled == 1) {
                    widget.listItems[widget.index].enabled = 0;
                    _sendMessage('1');
                    _sendMessage((widget.index + 1).toString());
                  } else {
                    widget.listItems[widget.index].enabled = 1;
                    _sendMessage('1');
                    _sendMessage((widget.index + 1).toString());
                  }
                });
              },
              child: new Container(
                  margin: const EdgeInsets.all(15.0),
                  child: new Icon(
                    (widget.listItems[widget.index].enabled == 1)
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    //color: Colors.red,
                    size: 30,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

void _sendMessage(String text) async {
  text = text.trim();

  if (text.length > 0) {
    try {
      connection.output.add(utf8.encode(text));
      await connection.output.allSent;
      print("Message sent");
    } catch (e) {
      print("Message send FAILED");
    }
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  //List<BluetoothDevice> devices;
  BluetoothDevice pedalBoard;
  //BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;
  bool isDisconnecting = false;


  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        //_bluetoothState = state;
      });
    });

    FlutterBluetoothSerial.instance
        .getBondedDevices().then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        print("Grabbed bonded devices");
        for (var i = 0; i < bondedDevices.length; i++)
        {
          //print(bondedDevices[i].name);
          if (bondedDevices[i].name == "HC-06")
          {
            pedalBoard = bondedDevices[i];

            BluetoothConnection.toAddress(pedalBoard.address).then((_connection) {
              print('Connected to the device');
              connection = _connection;
              setState(() {
                isConnecting = false;
                isDisconnecting = false;
              });
            }).catchError((error) {
              print('Cannot connect, exception occurred');
              print(error);
            });
            break;
          }
        }
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if (await FlutterBluetoothSerial.instance.isEnabled) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    });

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        //_bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        //_discoverableTimeoutTimer = null;
      });
    });
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
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 3.0),
              child: GestureDetector(
                onTap: () {
                  // New pop-up to save patch
                  _sendMessage('5');
                  _sendMessage('1');
                },
                child: new Container(
                  margin: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.looks_one_rounded,
                    color: Colors.white,
                    size: 24.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 3.0),
              child: GestureDetector(
                onTap: () {
                  // New pop-up to save patch
                  _sendMessage('5');
                  _sendMessage('2');
                },
                child: new Container(
                  margin: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.looks_two_rounded,
                    color: Colors.white,
                    size: 24.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 3.0),
              child: GestureDetector(
                onTap: () {
                  // New pop-up to save patch
                  _sendMessage('5');
                  _sendMessage('3');
                },
                child: new Container(
                  margin: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.looks_3_rounded,
                    color: Colors.white,
                    size: 24.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  // New pop-up to save patch
                  _saveEffect(context);
                },
                child: new Container(
                  margin: const EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.save,
                    color: Colors.white,
                    size: 24.0,
                  ),
                ),
              ),
            )
          ],
        ),
        // Body of the page to list effects.
        body: Column (
            mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  children: List.generate(
                    effects.length,
                        (index) {
                      return ListViewCard(
                        effects,
                        index,
                        Key('$index'),
                      );
                    },
                  ),
                ),
            ),
            FlatButton(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 60.0),
              color: Color(0xff042082),
              textColor: Colors.white,
              child: Text('Bypass'),
              onPressed: () {
                setState(() {
                  _sendMessage('6');
                });
              },
            ),
            new Divider(
              thickness: 0,
              color: Colors.white,
            ),
          ]),
        );

  }
}
