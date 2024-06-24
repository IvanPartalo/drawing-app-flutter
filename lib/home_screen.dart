import 'package:flutter/material.dart';
import 'package:painter_app/pop_up_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                Container(
                  margin: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  foregroundDecoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    shape: BoxShape.circle,
                  ),
                ),
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
                    child: CustomPaint(
                      painter: DrawingPainter(),
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

  @override
  void paint(Canvas canvas, Size size) {

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
