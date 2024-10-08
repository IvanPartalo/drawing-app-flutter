import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:painter_app/home_screen.dart';

class MoreMenu extends StatelessWidget{
  final DeleteAllCallback onDeleteAll;
  final SetLandscapeCallback onSetLandscape;
  final SetPortraitCallback onSetPortrait;
  final SaveImageCallback onSaveImage;
  final UploadImageCallback onUploadImage;
  final SetBackgroundCallback onBackroundChange;
  final SetBackgroundFilterCallback onBackgroundFilter;
  final DrawOvalCallback onDrawOvalSelected;
  final DrawRectangleCallback onDrawRectangleSelected;
  const MoreMenu({super.key, required this.onDeleteAll, required this.onSetLandscape, required this.onSetPortrait,
  required this.onSaveImage, required this.onUploadImage, required this.onBackroundChange, required this.onBackgroundFilter,
  required this.onDrawOvalSelected, required this.onDrawRectangleSelected});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton.icon(
          icon: const Icon(Icons.crop_portrait),
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
          style: ElevatedButton.styleFrom(minimumSize: Size(185, 35)),
          label: Text("Portrait"),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.crop_landscape),
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
          style: ElevatedButton.styleFrom(minimumSize: Size(185, 35)),
          label: Text("Landscape"),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.format_color_fill_outlined),
          onPressed: () {
            onBackroundChange();
          },
          label: Text("Fill background"),
          style: ElevatedButton.styleFrom(minimumSize: Size(185, 35)),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.filter_rounded),
          onPressed: () {
            Navigator.pop(context);
            onBackgroundFilter();
          },
          label: Text("Background filter"),
          style: ElevatedButton.styleFrom(minimumSize: Size(185, 35)),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.rectangle_outlined),
          onPressed: () {
            Navigator.pop(context);
            onDrawRectangleSelected();
          },
          label: Text("Draw rectangle"),
          style: ElevatedButton.styleFrom(minimumSize: Size(185, 35)),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.circle_outlined),
          onPressed: () {
            Navigator.pop(context);
            onDrawOvalSelected();
          },
          label: Text("Draw oval"),
          style: ElevatedButton.styleFrom(minimumSize: Size(185, 35)),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.upload_sharp),
          onPressed: () {
            onUploadImage();
          },
          style: ElevatedButton.styleFrom(minimumSize: Size(185, 35)),
          label: Text("Upload image"),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.save_alt),
          onPressed: () {
            onSaveImage();
          },
          style: ElevatedButton.styleFrom(minimumSize: Size(185, 35)),
          label: Text("Save drawing"),

        ),
        ElevatedButton.icon(
        icon: const Icon(Icons.delete),
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
          style: ElevatedButton.styleFrom(minimumSize: Size(185, 35)),
        label: Text("Delete drawing"),
        ),
      ],
    );
  }

}