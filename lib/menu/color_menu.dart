import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:painter_app/home_screen.dart';
import 'package:painter_app/menu/pop_up_color.dart';

class ColorMenu extends StatefulWidget{
  final ColorCallback onColorSelected;
  final Color selectedColor;
  const ColorMenu ({super.key, required this.onColorSelected, required this.selectedColor});
  @override
  State<StatefulWidget> createState() => _ColorMenuState(onColorSelected, selectedColor);

}

class _ColorMenuState extends State<ColorMenu>{
  final ColorCallback onColorSelected;
  Color selectedColor;
  _ColorMenuState(this.onColorSelected, this.selectedColor);
  final colors = const [Colors.black, Colors.red, Colors.green, Colors.blue, Colors.yellow, Colors.orange];
  changeColor(Color color){
    selectedColor = color;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children:
            List.generate(6, (index){
              return GestureDetector(
                onTap: () => {
                  setState(() { selectedColor = colors[index]; }),
                  onColorSelected(colors[index])
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(6.0, 10.0, 6.0, 0.0),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: colors[index],
                    shape: BoxShape.circle,
                  ),
                  foregroundDecoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
          child: ElevatedButton.icon(
            onPressed: () {
                AlertDialog alert = AlertDialog(
                  title: Text("Pick a color"),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: selectedColor,
                      onColorChanged: changeColor,
                      enableAlpha: false,
                      displayThumbColor: true,
                      colorPickerWidth: 300,
                      pickerAreaHeightPercent: 0.7,
                      hexInputBar: false,
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text('Submit'),
                      onPressed: () {
                        onColorSelected(selectedColor);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
            },
              label: const Text("Custom color"),
              icon: const Icon(Icons.color_lens_outlined),
          ),
        ),
      ],
    );
  }

}