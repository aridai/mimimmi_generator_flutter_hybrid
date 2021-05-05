import 'package:flutter/material.dart';
import 'package:mimimmi_generator_flutter_hybrid/generator_page.dart';
import 'package:mimimmi_generator_flutter_hybrid/mimimmi_canvas.dart';
import 'package:mimimmi_generator_flutter_hybrid/mimimmi_output.dart';

void main() {
  MimimmiCanvas.init();
  MimimmiOutput.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ミミッミジェネレータ',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GeneratorPage(),
    );
  }
}
