import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:painter_app/components/line.dart';
import 'package:painter_app/menu/pop_up_button.dart';
import 'package:painter_app/menu/pop_up_color.dart';
import 'package:painter_app/menu/pop_up_more.dart';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';
import 'package:random_string_generator/random_string_generator.dart';
import 'package:toastification/toastification.dart';
import 'package:vector_math/vector_math_64.dart';

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
  Color selectedColor = Color.fromARGB(255, 255, 0, 0);
  double selectedThickness = 1.0;
  ui.Image? _image;
  ui.Image? placeHolderImage;
  bool backgroundChosen = false;
  bool imageLoaded = false;
  bool isPortrait = true;
  int zoomLevel = 1;
  bool zoomingIn = true;
  var zoomingCoords = [0.0, 0.0, 0.0, 0.0];
  var eraseToggled = false;
  final picker = ImagePicker();
  Matrix4 transformationMatrix = Matrix4.identity();

  @override
  void initState() {
    super.initState();
    loadInitImage();
  }

  //Probati sa nekom boljom strukturom podataka za cuvanje koordinata umesto obicnog niza...
  saveZoomingCoord(double x, double y){
    if(zoomLevel == 1){
      zoomingCoords[0] = x;
      zoomingCoords[1] = y;
    }
    else{
      zoomingCoords[2] = x;
      zoomingCoords[3] = y;
    }
  }

  void _handleDoubleTap(TapDownDetails details) {
    setState(() {
      final position = details.localPosition;
      final Matrix4 inverseMatrix = Matrix4.copy(transformationMatrix)..invert();
      final Vector4 tapInCanvas = inverseMatrix.transform(Vector4(position.dx, position.dy, 0, 1));
      double x = tapInCanvas.x;
      double y = tapInCanvas.y;
      double scale;
      if(zoomingIn){
        scale = 1.5;
        saveZoomingCoord(x, y);
        zoomLevel++;
      }
      else{
        scale = 1/1.5;
        if(zoomLevel == 3){
          x = zoomingCoords[2];
          y = zoomingCoords[3];
        }
        else{
          x = zoomingCoords[0];
          y = zoomingCoords[1];
        }
        zoomLevel--;
      }
      if(zoomLevel == 3){
        zoomingIn = false;
      }
      if(zoomLevel == 1){
        zoomingIn = true;
      }
      final Matrix4 zoomMatrix = Matrix4.identity()
        ..translate(x, y)
        ..scale(scale)
        ..translate(-x, -y);

      transformationMatrix = transformationMatrix.multiplied(zoomMatrix);
    });
  }
  loadInitImage() async{
    placeHolderImage = await loadPlaceholderImage('assets/logo.png');
    setState(() {});
  }

  // za ucitavanje slika pomoc od: https://itchybumr.medium.com/flutter-tutorial-image-picker-picking-photos-from-camera-or-photo-gallery-5243a5eff6b4
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() async {
      if (pickedFile != null) {
        imageLoaded = false;
        _image = await loadImageFromFile(File(pickedFile.path));
        backgroundChosen = true;
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() async {
      if (pickedFile != null) {
        imageLoaded = false;
        _image = await loadImageFromFile(File(pickedFile.path));
        backgroundChosen = true;
      }
    });
  }

  Future<ui.Image> loadImageFromFile(File file) async {
    Uint8List imageBytes = await file.readAsBytes();
    Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      completer.complete(img);
    });
    imageLoaded = true;
    return completer.future;
  }

  Future<ui.Image> loadPlaceholderImage(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }

  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Photo Gallery'),
            onPressed: () {
              Navigator.of(context).pop();
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Camera'),
            onPressed: () {
              Navigator.of(context).pop();
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

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
      backgroundChosen = false;
      imageLoaded = false;
    });
  }
  void _setLandscapeMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    setState(() { isPortrait = false; });
    _deleteAll();
  }
  void _setPortraitMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    setState(() { isPortrait = true; });
    _deleteAll();
  }
  void _saveAsImage() async{
    try {
      double scaleFactor = 1.5;
      ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      Canvas canvas = Canvas(pictureRecorder);
      DrawingPainter painter;
      if(_image != null){
        painter = DrawingPainter(currentLines, _image!, backgroundChosen, imageLoaded, transformationMatrix);
      }
      else{
        painter = DrawingPainter(currentLines, placeHolderImage!, backgroundChosen, imageLoaded, transformationMatrix);
      }
      Size? size = isPortrait ? const Size(360, 661.3) : const Size(731.3, 260);
      //moram da obojim pozadinu u belo rucno :(
      Paint paint = Paint();
      paint.color = Color.fromARGB(255, 255, 255, 255);
      canvas.scale(scaleFactor);
      canvas.drawRect(Rect.fromLTWH(0, 0, size!.width, size.height), paint);
      painter.paint(canvas, size);
      ui.Image image = await pictureRecorder.endRecording().toImage(
          (size.width * scaleFactor).floor(), (size.height * scaleFactor).floor());
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
        title: const Text("Saving the drawing"),
        autoCloseDuration: const Duration(seconds: 2),
        alignment: Alignment.bottomCenter,
      );
    }
    catch(e){
      print("Error while saving image: $e");
    }
  }

  Offset _transformOffset(Offset offset) {
    final Matrix4 inverseMatrix = Matrix4.copy(transformationMatrix)..invert();
    final Vector4 transformedVector = inverseMatrix.transform(Vector4(offset.dx, offset.dy, 0, 1));
    return Offset(transformedVector.x, transformedVector.y);
  }

  @override
  Widget build(BuildContext context) {
    if(placeHolderImage == null){
      return const Center(child: CircularProgressIndicator());
    }
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
                IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: eraseToggled ? Color.fromARGB(255, 255, 0, 0) : Color.fromARGB(255, 200, 200, 200),
                  ),
                  onPressed: (){
                    setState(() {
                      eraseToggled = !eraseToggled;
                    });
                  },
                ),
                IconButton(
                    onPressed: () {
                      showOptions();
                    },
                    icon: const Icon(Icons.upload_sharp)
                ),
                PopUpMore(onDeleteAll: _deleteAll, onSetLandscape: _setLandscapeMode, onSetPortrait: _setPortraitMode,
                  onSaveImage: _saveAsImage,),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onDoubleTapDown: _handleDoubleTap,
                    onPanStart: (details){
                        setState(() {
                          currentLine = Line(
                              color: eraseToggled ? Color.fromARGB(255, 255, 255, 255) : selectedColor,
                              thickness: selectedThickness,
                              points: [_transformOffset(details.localPosition)]
                          );
                          currentLines.add(currentLine!);
                          undoLines.clear();
                        });
                    },
                    onPanUpdate: (details){
                        setState(() {
                          if (currentLine == null) {
                            return;
                          }
                          currentLine?.points.add(_transformOffset(details.localPosition));
                          currentLines.last = currentLine!;
                        });
                    },
                    onPanEnd: (_){
                        currentLine = null;
                    },
                    child: CustomPaint(
                      painter: _image != null
                          ? DrawingPainter(currentLines, _image!, backgroundChosen, imageLoaded, transformationMatrix)
                          : DrawingPainter(currentLines, placeHolderImage!, backgroundChosen, imageLoaded, transformationMatrix),

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

//IZDVOJITI KLASU U ZASEBAN FAJL!
class DrawingPainter extends CustomPainter {
  late List<Line> linesToDraw;
  late File image;
  late ui.Image backgroundImage;
  bool backgroundChosen = false;
  bool imageLoaded = false;
  late Size painterCanvasSize;
  final Matrix4 transformationMatrix;

  DrawingPainter(List<Line> lines, ui.Image i, this.backgroundChosen, this.imageLoaded, this.transformationMatrix){
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
    paint.color = Color.fromARGB(255, 255, 255, 255);
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
