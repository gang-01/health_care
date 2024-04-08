import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  final dynamic weatherData;

  const WeatherScreen({Key? key, required this.weatherData}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late String cityName;
  late int temp;
  late String currentDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateData(widget.weatherData);
  }

  void updateData(dynamic weatherData) {
    var dt = weatherData['dt'];
    var timezone = weatherData['timezone'];
    var tempTime = DateTime.fromMillisecondsSinceEpoch((dt+timezone) * 1000);

    cityName = weatherData['name'];
    temp = weatherData['main']['temp'].round();
    currentDate = DateFormat('yyyy-MM-dd, HH:mm:ss').format(tempTime);
    debugPrint('cityName[$cityName], temp[${weatherData['main']['temp'].toString()}]');
    debugPrint('dt[$dt], timezone[$timezone], Date[$currentDate]');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(cityName, style: const TextStyle(fontSize: 30)),
              const SizedBox(height: 40),
              Text(currentDate, style: const TextStyle(fontSize: 30)),
              const SizedBox(height: 40),
              Text(temp.toString(), style: const TextStyle(fontSize: 30)),
            ],
          ),
        ),
      ),
    );
  }
}