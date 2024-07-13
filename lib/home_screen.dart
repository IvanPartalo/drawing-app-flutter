import 'package:flutter/material.dart';
import 'package:painter_app/components/line.dart';
import 'package:painter_app/menu/pop_up_button.dart';
import 'package:painter_app/menu/pop_up_color.dart';

typedef ColorCallback = void Function(Color color);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Line? currentLine;
  List<Line> currentLines = [];
  Color selectedColor = Colors.red;

  void _updateColor(Color color) {
    setState(() {
      selectedColor = color;
    });
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
                  onPressed: () {},
                  icon: const Icon(Icons.undo)
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.redo)
                ),
                const PopUpButton(),
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
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert_sharp)
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 3.0), // Add a border to visualize dimensions
                    ),
                    child: GestureDetector(
                      onPanStart: (details){
                        setState(() {
                          currentLine = Line(
                              color: selectedColor,
                              points: [details.localPosition]
                          );
                          currentLines.add(currentLine!);
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
      paint.strokeWidth = 1.0;
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
