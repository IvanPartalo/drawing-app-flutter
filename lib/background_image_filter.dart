import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:painter_app/components/filters.dart';
import 'package:painter_app/home_screen.dart';
import 'package:vector_math/vector_math.dart' as vec;

class ImageFilter extends StatefulWidget{
  final ui.Image image;
  const ImageFilter({super.key, required this.image});
  @override
  State<StatefulWidget> createState() => _ImageFilterState(image);
}

class _ImageFilterState extends State<ImageFilter>{
  late ui.Image image;
  late ui.Image imageToSave;
  List<double> filter = NO_FILTER;
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  _ImageFilterState(this.image);

  Future<void> _saveFilteredImage() async{
    filter;
    RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image tmpImage = await boundary.toImage(pixelRatio: 3.0);
    setState(() {
      imageToSave = tmpImage;
    });
  }
  @override
  Widget build(BuildContext context){
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RepaintBoundary(
              key: _repaintBoundaryKey,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: size.height - 200,
                  maxWidth: size.width,
                ),
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(filter),
                  child: RawImage(
                    image: image,
                  ),
                ),
              ),
            ),
            OverflowBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton( child: const Text('No filter', style: TextStyle(color: Colors.white),), onPressed: () {
                  setState(() {
                    filter = NO_FILTER;
                  });
                  _saveFilteredImage();
                }),
                TextButton( child: const Text('Grayscale', style: TextStyle(color: Colors.white),), onPressed: () {
                  setState(() {
                    filter = GRAYSCALE_MATRIX;
                  });
                  _saveFilteredImage();
                }),
                TextButton( child: const Text('Black white', style: TextStyle(color: Colors.white),), onPressed: () {
                  setState(() {
                    filter = BLACK_AND_WHITE;
                  });
                  _saveFilteredImage();
                }),
              ],
            ),
            OverflowBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton( child: const Text('Yellow', style: TextStyle(color: Colors.white),), onPressed: () {
                  setState(() {
                    filter = YELLOW;
                  });
                  _saveFilteredImage();
                }),
                TextButton( child: const Text('Old times', style: TextStyle(color: Colors.white),), onPressed: () {
                  setState(() {
                    filter = OLD_TIMES;
                  });
                  _saveFilteredImage();
                }),
                TextButton( child: const Text('Milk', style: TextStyle(color: Colors.white),), onPressed: () {
                  setState(() {
                    filter = MILK;
                  });
                  _saveFilteredImage();
                }),
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  await _saveFilteredImage();
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen(image: imageToSave, backgroundChosen: true, imageLoaded: true,)));
                },
                child: Text("Submit")),
          ],
        ),

      ),
    );
  }
}