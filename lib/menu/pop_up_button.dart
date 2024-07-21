import 'package:flutter/cupertino.dart';
import 'package:painter_app/home_screen.dart';
import 'package:painter_app/menu/thickness_menu.dart';
import 'package:popover/popover.dart';

class PopUpButton extends StatelessWidget{
  final ThicknessCallback onThicknessChanged;
  final double thickness;
  const PopUpButton({super.key, required this.onThicknessChanged, required this.thickness});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPopover(context: context, bodyBuilder: (context) =>
          ThicknessMenu(onThicknessChanged: (thickness) {
            onThicknessChanged(thickness);
          }
          , thickness: thickness),
      width: 220,
      height: 90),
      child: SizedBox(
        height: 30,
        width: 30,
        // icon link: https://www.flaticon.com/free-icon/stroke_5598084?term=stroke&page=1&position=38&origin=search&related_id=5598084
        child: Image.asset('lib/icons/stroke.png'),
      ),
    );
  }
}