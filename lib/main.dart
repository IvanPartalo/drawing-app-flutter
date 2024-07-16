import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:painter_app/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_){
    runApp(MaterialApp(
      home: Home(),
    ));
  });
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}
