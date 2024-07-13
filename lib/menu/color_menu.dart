import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:painter_app/home_screen.dart';
import 'package:painter_app/menu/pop_up_color.dart';

class ColorMenu extends StatelessWidget{
  final ColorCallback onColorSelected;
  const ColorMenu({super.key, required this.onColorSelected});
  final colors = const [Colors.black, Colors.red, Colors.green, Colors.blue, Colors.yellow, Colors.orange];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children:
            List.generate(6, (index){
              return GestureDetector(
                onTap: () => onColorSelected(colors[index]),
                child: Container(
                  margin: EdgeInsets.fromLTRB(6.0, 10.0, 6.0, 0.0),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: colors[index],
                    shape: BoxShape.circle,
                  ),
                  foregroundDecoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
        ),
      ],
    );
  }

}