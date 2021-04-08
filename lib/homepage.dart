import 'package:flutter/material.dart';
import 'patchData.dart';

List<Effect> effects = [flangerEff, delayEff, distortionEff];

Effect flangerEff =
    Effect(id: 0, name: 'Flanger', enabled: 0, effectValue: 0.0);

Effect delayEff = Effect(id: 1, name: 'Delay', enabled: 0, effectValue: 0.0);

Effect distortionEff =
    Effect(id: 2, name: 'Distortion', enabled: 0, effectValue: 0.0);

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

// Builds the effect rows
class _ListViewCard extends State<ListViewCard> {
  @override
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
                  } else {
                    widget.listItems[widget.index].enabled = 1;
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Icon(
                Icons.reorder,
                color: Colors.grey,
                size: 24.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    super.initState();
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
