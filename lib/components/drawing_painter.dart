import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:painter_app/components/display_text.dart';
import 'package:painter_app/components/line.dart';
import 'dart:ui' as ui;

class DrawingPainter extends CustomPainter {
  late List<Line> linesToDraw;
  final List<DisplayText> texts;
  late File image;
  late ui.Image backgroundImage;
  bool backgroundChosen = false;
  bool imageLoaded = false;
  late Size painterCanvasSize;
  final Matrix4 transformationMatrix;
  final Color backgroundColor;

  DrawingPainter(List<Line> lines, ui.Image i, this.backgroundChosen, this.imageLoaded, this.transformationMatrix,
      this.texts, this.backgroundColor){
    if(lines == null){
      linesToDraw = [];
    }else {
      linesToDraw = lines;
    }
    backgroundImage = i;
  }
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.transform(transformationMatrix.storage);
    final paint = Paint();
    painterCanvasSize = size;
    //deo za bojenje pozadine moze biti problem ako stalno iterativno crta pa da usporava
    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, size.width, size.height));
    paint.color = backgroundColor;
    canvas.drawPath(mainBackground, paint);
    if(backgroundChosen && imageLoaded){
      double scale = getScaleFactor(backgroundImage, size);
      double dx = (size.width - backgroundImage.width.toDouble() * scale ) / 2;
      double dy = (size.height - backgroundImage.height.toDouble() * scale ) / 2;
      canvas.save();
      canvas.translate(dx, dy);
      canvas.scale(scale, scale);
      canvas.drawImage(backgroundImage, Offset.zero, paint);
      canvas.restore();
    }
    for(var line in linesToDraw){
      paint.color = line.color;
      paint.strokeWidth = line.thickness;
      for(var i = 0; i < line.points.length - 1; i++){
        final currentPoint = line.points[i];
        final nextPoint = line.points[i+1];
        canvas.drawLine(currentPoint, nextPoint, paint);
      }
    }
    for (var textInfo in texts){
      final textSpan = TextSpan(text: textInfo.text, style: TextStyle(color: textInfo.textColor, fontSize: textInfo.fontSize));
      final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      textPainter.layout();
      textPainter.paint(canvas, textInfo.position);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    //mozda bih mogao promeniti kada se ponovo crta kako bih optimizovao aplikaciju
    return true;
  }

  double getScaleFactor(ui.Image image, Size size){
    double scaleX = size.width / image.width.toDouble();
    double scaleY = size.height / image.height.toDouble();
    double scale = scaleX < scaleY ? scaleX : scaleY;
    return scale;
  }

  Size getCanvasSize(){
    return painterCanvasSize;
  }

}