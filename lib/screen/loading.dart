import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:health/screen/HomeScreen.dart';
import 'package:http/http.dart' as http;
import 'package:health/data/my_location.dart';
import 'package:health/data/network.dart';
import 'package:health/screen/Weather_Screen.dart';

const apiKey = '4f8d75a470d4a959cab723d650081ade';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  late double latitude;
  late double longitude;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      MyLocation myLocation = MyLocation();
      await myLocation.getMyCurrentLocation();
      latitude = myLocation.latitude;
      longitude = myLocation.longitude;
      print(latitude);
      print(longitude);

      Network network = Network(
          'https://api.openweathermap.org/data/2.5/weather'
              '?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric',
          'https://api.openweathermap.org/data/2.5/air_pollution'
              '?lat=$latitude&lon=$longitude&appid=$apiKey');

      var weatherData = await network.getJsonData();
      print(weatherData);

      var airData = await network.getAirData();
      print(airData);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return WeatherScreen(
          parseWeatherData: weatherData,
          parseAirPollution: airData,
        );
      }));
    } catch (e) {
      print(e);
      // 에러 처리 추가 가능
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // 로딩 인디케이터 표시
      ),
    );
  }
}
