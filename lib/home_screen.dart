import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:painter_app/components/line.dart';
import 'package:painter_app/menu/pop_up_button.dart';
import 'package:painter_app/menu/pop_up_color.dart';
import 'package:painter_app/menu/pop_up_more.dart';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';
import 'package:random_string_generator/random_string_generator.dart';
import 'package:toastification/toastification.dart';

typedef ColorCallback = void Function(Color color);
typedef ThicknessCallback = void Function(double thickness);
typedef DeleteAllCallback = void Function();
typedef SetLandscapeCallback = void Function();
typedef SetPortraitCallback = void Function();
typedef SaveImageCallback = void Function();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Line? currentLine;
  List<Line> currentLines = [];
  List<Line> undoLines = [];
  Color selectedColor = Colors.red;
  double selectedThickness = 1.0;

  void _updateColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }
  void _updateThickness(double thickness) {
    setState(() {
      selectedThickness = thickness;
    });
  }
  void _deleteAll() {
    setState(() {
      currentLines = [];
      undoLines = [];
    });
  }
  void _setLandscapeMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _deleteAll();
  }
  void _setPortraitMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _deleteAll();
  }
  void _saveAsImage() async{
    try {
      ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      Canvas canvas = Canvas(pictureRecorder);
      DrawingPainter painter = DrawingPainter(currentLines);
      Size? size = context.size;
      //moram da obojim pozadinu u belo rucno :(
      Paint paint = Paint();
      paint.color = Colors.white;
      canvas.drawRect(Rect.fromLTWH(0, 0, size!.width, size.height), paint);

      painter.paint(canvas, size);
      ui.Image image = await pictureRecorder.endRecording().toImage(
          size.width.floor(), size.height.floor());
      var pngBytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final Directory tempDir = await getTemporaryDirectory();
      var generator = RandomStringGenerator(fixedLength: 10, hasSymbols: false);
      String randomName = generator.generate();
      final String filePath = '${tempDir.path}/$randomName.png';
      final File file = File(filePath);
      await file.writeAsBytes(pngBytes!.buffer.asUint8List(), flush: true);
      await GallerySaver.saveImage(file.path);
      toastification.show(
        context: context,
        title: const Text("Drawing successfully saved"),
        autoCloseDuration: const Duration(seconds: 2),
        alignment: Alignment.bottomCenter,
      );
    }
    catch(e){
      print("Error while saving image: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: <Widget>[
            Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20.0),
                  )
                ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    if(undoLines.length < 21) {
                      undoLines.add(currentLines.last);
                      currentLines.removeLast();
                    }
                  },
                  icon: const Icon(Icons.undo)
                ),
                IconButton(
                    onPressed: () {
                      if(undoLines.isNotEmpty) {
                        currentLines.add(undoLines.last);
                        undoLines.removeLast();
                      }
                    },
                    icon: const Icon(Icons.redo)
                ),
                PopUpButton(thickness: selectedThickness, onThicknessChanged: _updateThickness,),
                PopUpColor(selectedColor: selectedColor, onColorSelected: _updateColor,),
                SizedBox(
                  height: 40,
                  //icon link: https://www.flaticon.com/free-icon/eraser_9515002?term=erase&page=1&position=10&origin=tag&related_id=9515002
                  child: Image.asset('lib/icons/eraser.png'),
                ),
                IconButton(
                    onPressed: () {
                    },
                    icon: const Icon(Icons.text_format)
                ),
                PopUpMore(onDeleteAll: _deleteAll, onSetLandscape: _setLandscapeMode, onSetPortrait: _setPortraitMode,
                onSaveImage: _saveAsImage,),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onPanStart: (details){
                      setState(() {
                        currentLine = Line(
                            color: selectedColor,
                            thickness: selectedThickness,
                            points: [details.localPosition]
                        );
                        currentLines.add(currentLine!);
                        undoLines.clear();
                      });
                    },
                    onPanUpdate: (details){
                      setState(() {
                        if(currentLine == null){
                          return;
                        }
                        currentLine?.points.add(details.localPosition);
                        currentLines.last = currentLine!;
                      });
                    },
                    onPanEnd: (_){
                      currentLine = null;
                    },
                    child: CustomPaint(
                      painter: DrawingPainter(currentLines),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 100,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

}

class DrawingPainter extends CustomPainter {
  late List<Line> linesToDraw;
  DrawingPainter(List<Line> lines){
    if(lines == null){
      linesToDraw = [];
    }else {
      linesToDraw = lines;
    }
  }
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for(var line in linesToDraw){
      paint.color = line.color;
      paint.strokeWidth = line.thickness;
      for(var i = 0; i < line.points.length - 1; i++){
        final currentPoint = line.points[i];
        final nextPoint = line.points[i+1];
        canvas.drawLine(currentPoint, nextPoint, paint);
      }
    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
