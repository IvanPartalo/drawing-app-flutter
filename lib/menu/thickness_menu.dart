import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:painter_app/home_screen.dart';

class ThicknessMenu extends StatefulWidget{
  final ThicknessCallback onThicknessChanged;
  final double thickness;
  const ThicknessMenu({super.key, required this.onThicknessChanged, required this.thickness});
  @override
  State<StatefulWidget> createState() => _ThicknessMenuState(onThicknessChanged, thickness);
}

class _ThicknessMenuState extends State<ThicknessMenu>{
  late double thickness;
  late ThicknessCallback onThicknessChanged;
  _ThicknessMenuState(ThicknessCallback callback, this.thickness){
    onThicknessChanged = callback;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          child: Slider(
            value: thickness,
            onChanged: (newRating){
              setState(() {
                thickness = newRating;
                onThicknessChanged(newRating);
              });
            },
            min: 0,
            max: 10,
          ),
        ),
        Container(
          height: 40,
          child: Text(
              "Thickness: ${thickness.toStringAsFixed(2)}"
          ),
        ),
      ],
    );
  }

}
