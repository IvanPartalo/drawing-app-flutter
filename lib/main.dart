import 'package:flutter/material.dart';
import 'package:painter_app/home_screen.dart';

void main() => runApp(MaterialApp(
    home: Home(),
  ));

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}
