import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:painter_app/home_screen.dart';
import 'package:painter_app/menu/color_menu.dart';
import 'package:popover/popover.dart';


class PopUpColor extends StatelessWidget{
  final Color selectedColor;
  final ColorCallback onColorSelected;

  const PopUpColor({super.key, required this.selectedColor, required this.onColorSelected});

  void _showColorMenu(BuildContext context) {
    showPopover(
      context: context,
      bodyBuilder: (context) => ColorMenu(
        onColorSelected: (color) {
          onColorSelected(color);
          Navigator.pop(context); // Close the popover
        },
      ),
      width: 240,
      height: 90,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showColorMenu(context),
      child: Container(
        margin: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: selectedColor,
          shape: BoxShape.circle,
        ),
        foregroundDecoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}