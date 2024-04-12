import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:health/screen/Map.dart';
import 'package:health/screen/Login.dart';
import 'package:health/screen/Search.dart';
import 'package:health/screen/Weather_Screen.dart';
import 'package:health/screen/loading.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({Key? key}): super(key:key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  User? loggedUser;

  void getCurrentUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        loggedUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void iniState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context){
    final title= 'Health Care'; //AppBar에 넣을 문구

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: Scaffold(
        appBar: AppBar(
            title: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.lightGreen,
            leading: IconButton(
              icon: Icon(Icons.logout),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginSignupScreen()));
                  },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.map),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const map()),
                  );
                },
              )
            ],
        ),
        body:
        SafeArea(
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //행에 보여줄 item 개수
              childAspectRatio: 1, //가로,세로 비율
            ),
            children: [
              Container(
                color: Colors.redAccent,
                child: Loading(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: TextButton(onPressed: (){map();},
                      child: Text('현위치'),),
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
                color: Colors.white,
                  child: IconButton(
                    icon: Image.asset('assets/medicine.png'),
                    iconSize: 1,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Search()));
                    },
                )

              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    color: Colors.deepPurple,
                    child: Text('걸음수: '),
                  ),
                ],
              ),
              /*
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const map()),
                        );
                      },
                        child: Text('Search', style: TextStyle(fontSize: 25)),
                  )
                ],
              ),
              */
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

