import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'patchData.dart';

//Future<List<Patch>> patchesFromDB = patches();

Future patchesFromDB() async {
  List<Patch> patchesList = await patches();
  return patchesList;
}

class SavedPage extends StatelessWidget {
  SavedPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Saved",
          style: TextStyle(color: Color(0xffFFFFFF)),
        ),
        backgroundColor: Color(0xff042082),
      ),
      // Create list of artists from SQLite
      body: FutureBuilder<List<Patch>>(
        future: patches(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          return buildPatchList(context, snapshot.data);
        },
      ),
    );
  }
}

class ListViewCard extends StatefulWidget {
  final int index;
  final Key key;
  final List<Patch> listItems;

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
              },
              child: new Container(
                margin: const EdgeInsets.all(10.0),
                child: Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                  size: 24.0,
                ),),
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
          ],
        ),
      ),
    );
  }
}

Widget buildPatchList(BuildContext context, List<Patch> snapshot) {
  return FutureBuilder(
    builder: (context, patchReturned) {
      if (patchReturned.connectionState == ConnectionState.none &&
          patchReturned.hasData == null) {
        //print('project snapshot data is: ${projectSnap.data}');
        return Container();
      }
      return ListView.builder(
        itemCount: patchReturned.data.length,
        itemBuilder: (context, index) {
          Patch project = patchReturned.data[index];
          return Column(
            children: <Widget>[
              // Widget to display the list of project
            ],
          );
        },
      );
    },
    future: patchesFromDB(),
  );
}
