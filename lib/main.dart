import 'package:flutter/material.dart';
import 'package:health/screen/Login.dart';

void main() {
 runApp(
     MaterialApp(
       debugShowCheckedModeBanner: false,
       home: LoginPage(),
 )
 );
}

class Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Text('HEALTH', style: TextStyle(fontSize: 50)),
          ],
        ),
      ),
    );
  }
}