import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:painter_app/home_screen.dart';
import 'package:painter_app/menu/more_menu.dart';
import 'package:popover/popover.dart';

class PopUpMore extends StatelessWidget{
  final DeleteAllCallback onDeleteAll;
  final SetLandscapeCallback onSetLandscape;
  final SetPortraitCallback onSetPortrait;
  const PopUpMore({super.key, required this.onDeleteAll, required this.onSetLandscape, required this.onSetPortrait});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: IconButton(
            onPressed: () {
              showPopover(context: context, bodyBuilder: (context) => MoreMenu(
                onDeleteAll: (){
                  onDeleteAll();
                  Navigator.pop(context);
                },
                onSetLandscape: (){
                  onSetLandscape();
                  Navigator.pop(context);
                },
                onSetPortrait: (){
                  onSetPortrait();
                  Navigator.pop(context);
                },
              ),
                width: 150,
                height: 90,);
            },
            icon: const Icon(Icons.more_vert)
        ),
    );
  }
}