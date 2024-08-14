import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:painter_app/components/display_text.dart';
import 'package:painter_app/components/line.dart';
import 'dart:ui' as ui;

import 'package:painter_app/components/rectangle.dart';

class DrawingPainter extends CustomPainter {
  late List<Line> linesToDraw;
  late List<Rectangle> rectangles;
  late List<Rectangle> ovals;
  final List<DisplayText> texts;
  late File image;
  late ui.Image backgroundImage;
  bool backgroundChosen = false;
  bool imageLoaded = false;
  late Size painterCanvasSize;
  final Matrix4 transformationMatrix;
  final Color backgroundColor;

  DrawingPainter(List<Line> lines, ui.Image i, this.backgroundChosen, this.imageLoaded, this.transformationMatrix,
      this.texts, this.backgroundColor, this.rectangles, this.ovals){
    if(lines == null){
      linesToDraw = [];
    }else {
      linesToDraw = lines;
    }
    backgroundImage = i;
  }
  @override
  void paint(Canvas canvas, Size size) {
    painterCanvasSize = size;
    canvas.save();
    canvas.transform(transformationMatrix.storage);
    final paint = Paint();
    fillBackground(canvas, paint, size);
    if(backgroundChosen && imageLoaded){
      putBackgroundImage(canvas, paint, size);
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
    drawRectangles(canvas, paint);
    drawOvals(canvas, paint);
    for (var textInfo in texts){
      final textSpan = TextSpan(text: textInfo.text, style: TextStyle(color: textInfo.textColor, fontSize: textInfo.fontSize));
      final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      textPainter.layout();
      textPainter.paint(canvas, textInfo.position);
    }
    canvas.restore();
  }
  drawRectangles(Canvas canvas, Paint paint){
    paint.style = PaintingStyle.stroke;
    for(Rectangle rect in rectangles){
      Rect r = Rect.fromPoints(rect.startingPoint, rect.endPoint);
      paint.color = rect.color;
      paint.strokeWidth = rect.thickness;
      canvas.drawRect(r, paint);
    }
  }

  drawOvals(Canvas canvas, Paint paint){
    paint.style = PaintingStyle.stroke;
    for(Rectangle rect in ovals){
      Rect r = Rect.fromPoints(rect.startingPoint, rect.endPoint);
      paint.color = rect.color;
      paint.strokeWidth = rect.thickness;
      canvas.drawOval(r, paint);
    }
  }
  putBackgroundImage(Canvas canvas, Paint paint, Size size){
    double scale = getScaleFactor(backgroundImage, size);
    double dx = (size.width - backgroundImage.width.toDouble() * scale ) / 2;
    double dy = (size.height - backgroundImage.height.toDouble() * scale ) / 2;
    canvas.save();
    canvas.translate(dx, dy);
    canvas.scale(scale, scale);
    canvas.drawImage(backgroundImage, Offset.zero, paint);
    canvas.restore();
  }
  void fillBackground(Canvas canvas, Paint paint, Size size){
    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, size.width, size.height));
    paint.color = backgroundColor;
    canvas.drawPath(mainBackground, paint);
  }
  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
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