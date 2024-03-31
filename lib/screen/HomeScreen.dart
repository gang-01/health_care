import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget{
  const HomeScreen({Key? key}): super(key:key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: Text('Health Care'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [_Weather(), _Status()],
            ),
          ),
        ),
      ),
    );
  }
}

// 날씨 상태 보여주는 칸
class _Weather extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      //height: MediaQuery.of(context).size.height,
      //width: MediaQuery.of(context).size.width,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed:(){},icon:Icon(Icons.sunny)),
            Text(('weather')),
          ],
        ),
      ),
    );
  }
}

//건강상태 보여주는 칸
class _Status extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      //height: MediaQuery.of(context).size.height,
      //width: MediaQuery.of(context).size.width,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/med.jpg'),
            Text(('Status'))
          ],
        ),
      ),
    );
  }
}