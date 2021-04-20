import 'package:flutter/material.dart';
import 'patchData.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:convert';
import 'dart:typed_data';

BluetoothConnection connection;

List<Effect> effects = [flangerEff, distortionEff, reverbEff];

Effect flangerEff = Effect(id: 0, name: 'Flanger', enabled: 0, effectValue: 0.0);

Effect distortionEff = Effect(id: 1, name: 'Distortion', enabled: 0, effectValue: 0.0);

Effect reverbEff = Effect(id: 2, name: 'reverb', enabled: 0, effectValue: 0.0);

TextEditingController _effectName = TextEditingController();
String codeDialog;
String valueText;

// Assign the patch the next unused ID
// (NOT IMPLEMENTED YET)
findNewPatchID() {
  return 1;
}

// Show effect parameters that can be changed
class EffectSettings extends StatefulWidget {
  final String recordObject;
  double value = 0.0;
  EffectSettings(this.recordObject, this.value);

  @override
  _EffectSettings createState() => new _EffectSettings();
}

class _EffectSettings extends State<EffectSettings> {
  static const double minValue = 0;
  static const double maxValue = 10;

  void _setValue(double value) => setState(() => widget.value = value);

  @override
  Widget build(BuildContext context) {
    // New window
    return AlertDialog(
      title: new Text('${widget.recordObject} Settings'),
      content: new Text(
        '${widget.recordObject} Power: ${widget.value.toStringAsFixed(1)}',
      ),
      actions: <Widget>[
        // Effect intensity value
        Slider(
            value: widget.value,
            onChanged: _setValue,
            min: minValue,
            max: maxValue),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FlatButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              color: Colors.green,
              textColor: Colors.white,
              child: Text('Save'),
              onPressed: () {
                Navigator.pop(context, widget.value);
              },
            ),
          ],
        )
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
              decoration: InputDecoration(hintText: "Name of patch"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('Save'),
                onPressed: () {
                  Patch patchToSave = new Patch(
                      id: findNewPatchID(),
                      name: _effectName.value.toString(),
                      effects: effects);
                  insertPatch(patchToSave);
                  Navigator.pop(context);
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
                // Bring up settings page for that effect
                showDialog(
                    context: context,
                    builder: (_) {
                      return EffectSettings(widget.listItems[widget.index].name,
                          widget.listItems[widget.index].effectValue);
                    }).then((value) {
                  if (value != null) {
                    widget.listItems[widget.index].effectValue = value;
                    _sendMessage('3');
                    _sendMessage((widget.index + 1).toString());
                    // TO-DO: choose which parameter to edit
                    _sendMessage('1');
                    // TO-DO: dictate whether going up or down
                    _sendMessage('p');
                    // Tell board we are done editing
                    _sendMessage('z');
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
                      '${widget.listItems[widget.index].name}',
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
                    size: 30.0,
                  )),
            ),
            // Users press this to re-order items
            /*Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Icon(
                Icons.reorder,
                color: Colors.grey,
                size: 24.0,
              ),
            ),*/
          ],
        ),
      ),
    );
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
        // Ignore error, but notify state
        setState(() {});
      }
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

  // Function to let user re-order the enabled effects to get new sounds
  void _onReorder(int oldIndex, int newIndex) {
    setState(
      () {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final Effect item = effects.removeAt(oldIndex);
        effects.insert(newIndex, item);
      },
    );
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
        body: ReorderableListView(
          onReorder: _onReorder,
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
        ));
  }
}
