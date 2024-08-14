import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:painter_app/home_screen.dart';
import 'package:painter_app/menu/more_menu.dart';
import 'package:popover/popover.dart';

class PopUpMore extends StatelessWidget{
  final DeleteAllCallback onDeleteAll;
  final SetLandscapeCallback onSetLandscape;
  final SetPortraitCallback onSetPortrait;
  final SaveImageCallback onSaveImage;
  final UploadImageCallback onUploadImage;
  final SetBackgroundCallback onBackgroundChange;
  final SetBackgroundFilterCallback onBackgroundFilter;
  final DrawRectangleCallback onDrawRectangleSelected;
  final DrawOvalCallback onDrawOvalSelected;
  final bool isPortrait;
  const PopUpMore({super.key, required this.onDeleteAll, required this.onSetLandscape, required this.onSetPortrait,
  required this.onSaveImage, required this.onUploadImage, required this.isPortrait, required this.onBackgroundChange,
  required this.onBackgroundFilter, required this.onDrawRectangleSelected, required this.onDrawOvalSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: IconButton(
            onPressed: () {
              showPopover(context: context,
                direction: isPortrait ? PopoverDirection.bottom : PopoverDirection.left,
                bodyBuilder: (context) => MoreMenu(
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
                onSaveImage: (){
                  onSaveImage();
                  Navigator.pop(context);
                },
                onUploadImage: (){
                  onUploadImage();
                },
                onBackroundChange: (){
                  onBackgroundChange();
                  Navigator.pop(context);
                },
                onBackgroundFilter: (){
                  onBackgroundFilter();
                },
                onDrawOvalSelected: (){
                  onDrawOvalSelected();
                },
                onDrawRectangleSelected: (){
                  onDrawRectangleSelected();
                },
              ),
                width: 190,
                height: 440,);
            },
            icon: const Icon(Icons.more_vert)
        ),
    );
  }
}