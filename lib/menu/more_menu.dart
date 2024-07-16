import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:painter_app/home_screen.dart';

class MoreMenu extends StatelessWidget{
  final DeleteAllCallback onDeleteAll;
  final SetLandscapeCallback onSetLandscape;
  final SetPortraitCallback onSetPortrait;
  const MoreMenu({super.key, required this.onDeleteAll, required this.onSetLandscape, required this.onSetPortrait});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                onPressed: () {
                  if(MediaQuery.of(context).orientation == Orientation.landscape) {
                    Widget cancelButton = ElevatedButton(
                      child: Text("No"),
                      onPressed:  () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    );
                    Widget continueButton = ElevatedButton(
                      child: Text("Yes"),
                      onPressed:  () {
                        onSetPortrait();
                        Navigator.pop(context);
                      },
                    );
                    AlertDialog alert = AlertDialog(
                      title: Text("Changing of orientation"),
                      content: Text("Are you sure you want to switch to portrait? It will delete the current drawing."),
                      actions: [cancelButton, continueButton, ],
                    );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  }
                },
                icon: const Icon(Icons.crop_portrait)
            ),
            IconButton(
                onPressed: () {
                  if(MediaQuery.of(context).orientation == Orientation.portrait) {
                    Widget cancelButton = ElevatedButton(
                      child: Text("No"),
                      onPressed:  () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    );
                    Widget continueButton = ElevatedButton(
                      child: Text("Yes"),
                      onPressed:  () {
                        onSetLandscape();
                        Navigator.pop(context);
                      },
                    );
                    AlertDialog alert = AlertDialog(
                      title: Text("Changing of orientation"),
                      content: Text("Are you sure you want to switch to landscape? It will delete the current drawing."),
                      actions: [cancelButton, continueButton, ],
                    );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  }
                },
                icon: const Icon(Icons.crop_landscape)
            ),
            IconButton(
                onPressed: () {
                  Widget cancelButton = ElevatedButton(
                    child: Text("No"),
                    onPressed:  () {
                      //jednom za izbacivanje alert-a, jednom za meni
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  );
                  Widget continueButton = ElevatedButton(
                    child: Text("Yes"),
                    onPressed:  () {
                      onDeleteAll();
                      Navigator.pop(context);
                    },
                  );
                  AlertDialog alert = AlertDialog(
                    title: Text("Delete drawing"),
                    content: Text("Are you sure you want to delete this drawing?"),
                    actions: [cancelButton, continueButton, ],
                  );
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                },
                icon: const Icon(Icons.delete)
            ),
          ],
        ),
      ],
    );
  }

}