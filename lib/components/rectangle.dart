import 'dart:ui';

class Rectangle{
  Offset startingPoint;
  Offset endPoint;
  Color color;
  double thickness;
  Rectangle(Offset sp, Offset ep, Color c, double t) :
    startingPoint = sp,
    endPoint = ep,
    color = c,
    thickness = t;

}