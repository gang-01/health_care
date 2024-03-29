import 'package:flutter/material.dart';

void main() {
 runApp(MyApp());
 print('hello world');
}

class MyApp extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
        home: Scaffold(
          body: Center(child: Text('캡스톤2024')),
        ),

    );
  }
}