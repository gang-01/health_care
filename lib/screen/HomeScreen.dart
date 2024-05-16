import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:health/screen/Map.dart';
import 'package:health/screen/Login.dart';
import 'package:health/screen/Search.dart';
import 'package:health/screen/Weather_Screen.dart';
import 'package:health/screen/loading.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? loggedUser;
  String? selectedMood;
  List<String> moodHistory = [];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    loadMoodHistory();
  }

  void getCurrentUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          loggedUser = user;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadMoodHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      moodHistory = prefs.getStringList('moodHistory') ?? [];
    });
  }

  Future<void> saveMood() async {
    if (selectedMood != null) {
      String timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> updatedMoodHistory = [...moodHistory, '$selectedMood - $timestamp'];
      await prefs.setStringList('moodHistory', updatedMoodHistory);
      setState(() {
        moodHistory = updatedMoodHistory;
        selectedMood = null;
      });
    }
  }

  void resetMoodHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('moodHistory');
    setState(() {
      moodHistory = [];
    });
  }

  void showMoodHistory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('기록'),
          content: SingleChildScrollView(
            child: ListBody(
              children: moodHistory.map((mood) {
                return Text(mood);
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Health Care';

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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginSignupScreen()),
              );
            },
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.wb_sunny, size: 80, color: Colors.blue[200],),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Loading()),
                      );
                    },
                  ),
                  /*
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Loading()),
                        ); //버튼 누르면 다른 화면으로 이동하는 코드
                      },
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('날씨', style: TextStyle(color: Colors.white, fontSize: 20,
                          )),
                    ),
                  ),
                  */
                  SizedBox(width: 40),

                  /*
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: FloatingActionButton(
                      onPressed: () {
                        // 예약 버튼을 누를 때 다른 화면으로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => map()),
                        );
                      },
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('지도', style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ),
    */
                  IconButton(
                    icon: Icon(Icons.map, size: 80, color: Colors.green),
                    onPressed: () async {
                      final curPosition = await Geolocator.getCurrentPosition();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => map()),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Search()),
                        );
                      },
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('검색', style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ),
                  */
                  IconButton(
                    icon: Icon(Icons.search, size: 80, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Search()),
                      );
                    },
                  ),
                  SizedBox(width: 40),
                  /*
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('만보기', style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ),
                  */
                  IconButton(
                    icon: Icon(Icons.directions_walk, size: 80, color: Colors.orange[300]),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 80),
              Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('오늘 어떠셨나요? : '),
                      SizedBox(width: 16.0),
                      DropdownButton<String>(
                        value: selectedMood,
                        onChanged: (String? value) {
                          setState(() {
                            selectedMood = value;
                          });
                        },
                        items: <String>[
                          '🥰행복해요',
                          '😢슬퍼요',
                          '😡화나요',
                          '🤩신나요',
                          '😐그냥그래요',
                          '😴피곤해요',
                          '😚설레요',
                          '🤒아파요',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: showMoodHistory,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange, // Change the button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0), // Add rounded corners
                          ),
                        ),
                        child: Text(
                          '기록',
                          style: TextStyle(color: Colors.white, fontSize: 18), // Change the text color
                        ),
                      ),
                      ElevatedButton(
                        onPressed: saveMood,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen, // Change the button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0), // Add rounded corners
                          ),
                        ),
                        child: Text(
                          '저장',
                          style: TextStyle(color: Colors.white, fontSize: 18), // Change the text color
                        ),
                      ),
                      ElevatedButton(
                        onPressed: resetMoodHistory,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400], // Change the button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0), // Add rounded corners
                          ),
                        ),
                        child: Text(
                          'Reset',
                          style: TextStyle(color: Colors.white, fontSize: 18), // Change the text color
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ),
        ],
      ),
    ),
    ),
    );
  }
}
