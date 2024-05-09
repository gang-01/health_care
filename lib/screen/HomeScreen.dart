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
          actions: [
            IconButton(
              icon: Icon(Icons.map),
              onPressed: () async{
                final curPosition= await Geolocator.getCurrentPosition();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => map()),
                );
              },
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
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
                          child: TextButton(
                            onPressed: () {
                              /*
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const map()),
                              );
                               */
                            },
                            child: Text('만보기'),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Search()),
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        child: Image.asset('assets/med.png'),
                      ),
                    ),
                  ],
                ),
              ),
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
                            style: TextStyle(color: Colors.white), // Change the text color
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
                            style: TextStyle(color: Colors.white), // Change the text color
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
                            style: TextStyle(color: Colors.white), // Change the text color
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
