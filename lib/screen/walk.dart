import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

class WalkScreen extends StatefulWidget {
  @override
  _WalkScreenState createState() => _WalkScreenState();
}

class _WalkScreenState extends State<WalkScreen> {
  String _stepCountValue = '0';
  Stream<StepCount>? _stepCountStream;
  Stream<PedestrianStatus>? _pedestrianStatusStream;
  String _pedestrianStatus = '---';

  @override
  void initState() {
    super.initState();
    _initializePedometer();
  }

  void _initializePedometer() {
    _stepCountStream = Pedometer.stepCountStream;
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;

    _stepCountStream?.listen(_onStepCount).onError(_onStepCountError);
    _pedestrianStatusStream?.listen(_onPedestrianStatusChanged).onError(_onPedestrianStatusError);
  }

  void _onStepCount(StepCount event) {
    setState(() {
      _stepCountValue = event.steps.toString();
    });
  }

  void _onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _pedestrianStatus = event.status;
    });
  }

  void _onStepCountError(error) {
    setState(() {
      _stepCountValue = '0';
    });
  }

  void _onPedestrianStatusError(error) {
    setState(() {
      _pedestrianStatus = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '만보기',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.lightGreen, // Light green background color for AppBar
      ),
      body: Container(
        color: Colors.white, // Light gray background color for the screen
        padding: EdgeInsets.symmetric(horizontal: 20), // Add padding on the sides
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // Center text horizontally
            children: <Widget>[
              Text(
                '걸음 수 🐾 :',
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Text(
                _stepCountValue,
                style: TextStyle(
                    fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 30),
              Text(
                '상태 :',
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the row content horizontally
                children: <Widget>[
                  Icon(
                    _pedestrianStatus == 'walking'
                        ? Icons.directions_walk
                        : _pedestrianStatus == 'stopped'
                        ? Icons.accessibility_new
                        : Icons.error,
                    size: 50,
                    color: Colors.grey[300],
                  ),
                  SizedBox(width: 10),
                  Text(
                    _pedestrianStatus,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
