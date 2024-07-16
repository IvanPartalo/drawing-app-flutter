import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:painter_app/components/line.dart';
import 'package:painter_app/menu/pop_up_button.dart';
import 'package:painter_app/menu/pop_up_color.dart';
import 'package:painter_app/menu/pop_up_more.dart';

typedef ColorCallback = void Function(Color color);
typedef ThicknessCallback = void Function(double thickness);
typedef DeleteAllCallback = void Function();
typedef SetLandscapeCallback = void Function();
typedef SetPortraitCallback = void Function();

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
                    onPressed: () {},
                    icon: const Icon(Icons.text_format)
                ),
                PopUpMore(onDeleteAll: _deleteAll, onSetLandscape: _setLandscapeMode, onSetPortrait: _setPortraitMode,),
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
