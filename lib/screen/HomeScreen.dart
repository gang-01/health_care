import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:health/screen/Map.dart';
import 'package:health/screen/Login.dart';
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
      title: title,
      home: Scaffold(
        appBar: AppBar(
            title: Text(title),
            centerTitle: true,
            leading: TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginSignupScreen()));},
              child: Text('LogOut', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),)),
        ),
        body: SafeArea(
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
                    child: TextButton(onPressed: (){map();},child: Text('현위치'),),
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
                ],
              ),
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
/*
class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void getLocation() async {
    // 기본설정은 아래처럼 하면 자신의 위도/경도 위치를 알수 있다.
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint(position.toString());

    // Navigate to the new screen after getting the location
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Loading()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: getLocation,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              color: Colors.red,
              //borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.wb_sunny,
              size: 50,
              color: Colors.yellow,
            ),
          ),
        ),
      ),
    );
  }
}
*/
