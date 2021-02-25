import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ListViewCard extends StatefulWidget {
  final int index;
  final Key key;
  final List<Effect> listItems;

  ListViewCard(this.listItems, this.index, this.key);

  @override
  _ListViewCard createState() => _ListViewCard();
}

class Effect {
  String name;
  bool enabled = false;
  Effect(String name, bool enabled)
  {
    this.name = name;
    this.enabled = enabled;
  }
}

var flangerEff = Effect('Flanger', false);
var delayEff = Effect('Delay', false);
var distortionEff = Effect('Distortion', false);

final List<Effect> effects = [flangerEff, delayEff, distortionEff];


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
              },
              child: new Container(
                  margin: const EdgeInsets.all(10.0),
                child: Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                  size: 24.0,
                ),),
            ),
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
                  widget.listItems[widget.index].enabled =
                  !widget.listItems[widget.index].enabled;
                });
              },
              child: new Container(
                  margin: const EdgeInsets.all(15.0),
                  child: new Icon(
                    widget.listItems[widget.index].enabled
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    //color: Colors.red,
                    size: 30.0,
                  )),
            ),
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

    final List<int> colorCodes = <int>[600, 500, 100];

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
        ),
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
        )
      );
    }
  }