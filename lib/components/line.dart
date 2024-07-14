import 'package:flutter/material.dart';

class Line{
  List<Offset> points;
  Color color;
  double thickness;
  Line({this.points = const [], this.color = Colors.black, this.thickness = 1.0, });
}