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
    final title= 'Health Care'; //AppBar에 넣을 문구

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(title: Text(title),centerTitle: true),
        body: SafeArea(
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //행에 보여줄 item 개수
              childAspectRatio: 1, //가로,세로 비율
            ),
            children: [
              Container(
                color: Colors.redAccent,
                child: Icon(Icons.sunny),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Text('현위치: '),
                  ),
                  Container(
                    child: Text('날씨에 따른 주의사항: '),
                  ),
                  Container(
                    child: Text('미세먼지: '),
                  )
                ],
              ),
              Container(
                color: Colors.black,
                child: Image.asset('assets/med.jpg'),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    color: Colors.deepPurple,
                    child: Text('걸음수: '),
                  ),
                  Container(
                    color: Colors.blue,
                    child: Text('연령대별 고민 질환'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
