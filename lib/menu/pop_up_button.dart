import 'package:flutter/cupertino.dart';
import 'package:painter_app/menu/thickness_menu.dart';
import 'package:popover/popover.dart';

class PopUpButton extends StatelessWidget{
  const PopUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPopover(context: context, bodyBuilder: (context) => ThicknessMenu(),
      width: 220,
      height: 120),
      child: SizedBox(
        height: 40,
        // icon link: https://www.flaticon.com/free-icon/stroke_5598084?term=stroke&page=1&position=38&origin=search&related_id=5598084
        child: Image.asset('lib/icons/stroke.png'),
      ),
    );
  }
}