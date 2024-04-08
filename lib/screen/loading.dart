import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:health/screen/HomeScreen.dart';
import 'package:http/http.dart' as http;
import 'package:health/data/my_location.dart';
import 'package:health/data/network.dart';
import 'package:health/screen/Weather_Screen.dart';
import 'package:intl/intl.dart';

// 키값은 회원가입후 무료로 1천건까지 조회가능한 키.
const apiKey = '4f8d75a470d4a959cab723d650081ade';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  late double latitude;
  late double longitude;

  @override
  void initState() {
    super.initState();
    //getLocation();
  }

  void getLocation() async {
    // 위도/경도 정보 가져오기
    MyLocation myLocation = MyLocation();
    await myLocation.getMyCurrentLocation();
    latitude = myLocation.latitude;
    longitude = myLocation.longitude;
    debugPrint('loading.dart >> ' + latitude.toString() +' / ' +longitude.toString());

// 현재 에뮬은 밀라노로 설정
//https://api.openweathermap.org/data/2.5/weather?lat=45.4642033&lon=9.1899817&appid=1e1a2b8f6d9b5311cd82d001e7b20131&units=metric

    // 해당 위도/경도의 날씨 정보 가져오기
    String baseApi = 'https://api.openweathermap.org/data/2.5/weather';
    Network network = Network(
        '$baseApi?lat=${latitude.toString()}&lon=${longitude.toString()}&appid=$apiKey&units=metric');
    var weatherData = await network.getJsonData();
    debugPrint(weatherData.toString());

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WeatherScreen(weatherData: weatherData)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            debugPrint('clicked~~');
            getLocation();
          },
          child: const Text('Get my location',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
