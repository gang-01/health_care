import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:health/screen/HomeScreen.dart';
import 'package:http/http.dart' as http;
import 'package:health/data/my_location.dart';
import 'package:health/data/network.dart';
import 'package:health/screen/Weather_Screen.dart';
import 'package:intl/intl.dart';
import 'package:health/model/current_weather.dart';

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
    // TODO: implement initState
    super.initState();
    getLocation();
    // fetchData();
  }

  void getLocation() async {
    MyLocation myLocation = MyLocation();

    await myLocation.getMyCurrentLocation();
    latitude = myLocation.latitude;
    longitude = myLocation.longitude;
    debugPrint('loading.dart >> ' + latitude.toString() +' / ' +longitude.toString());

    String baseApi = 'https://api.openweathermap.org/data/2.5/weather';
    Network network = Network(
        '$baseApi?lat=${latitude.toString()}&lon=${longitude.toString()}&appid=$apiKey&units=metric&lang=kr');
    var weatherData = await network.getJsonData();
    debugPrint(weatherData.toString());

    CurrentWeather currentWeather = CurrentWeather.fromJson(weatherData);
    debugPrint(currentWeather.name);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WeatherScreen(weatherData: currentWeather)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            debugPrint('ElevatedButton clicked~~');
          },
          child: const Text(
            'Get my location',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}