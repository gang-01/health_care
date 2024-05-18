import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:health/screen/HomeScreen.dart';
import 'package:google_maps_webservice/places.dart';

class map extends StatefulWidget{
  static const CameraPosition _smu =
  CameraPosition(target: LatLng(36.832225, 127.177981),
      zoom: 15);

  const map({super.key});
  @override
  _map createState() => _map();
}

class _map extends State<map> {
  late GoogleMapController mapController;
  late LatLng currentLocation;
  List<Marker> markers=[];

  final _markers = <Marker>{};
  final _users = [
    {
      "placeId": "장소",
      "latitude": 36.832225,
      "longitude": 127.177981,
    }
  ];

  @override
  void initState(){
    _markers.addAll(_users.map(
            (e) => Marker(
            markerId: MarkerId(e['placeId'] as String),
            infoWindow: InfoWindow(title: e['placeId'] as String),
            position: LatLng(
              e['latitude'] as double,
              e['longitude'] as double,
            )
        )
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: renderAppBar(),
        body: GoogleMap(
          initialCameraPosition: map._smu,
          myLocationEnabled: true,
          mapType: MapType.normal,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,

          markers: _markers,
        ),
    );
  }
}

AppBar renderAppBar() {
  return AppBar(
    title: Text(
      'Health Care',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
    ),
    backgroundColor: Colors.lightGreen,
  );
}


//위치 권한 관리
Future<String> checkPermission() async {
  final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

  if (!isLocationEnabled) {
    return '위치 서비스를 활성화해주세요.';
  }
  LocationPermission checkdePermission = await Geolocator.checkPermission();

  if (checkdePermission == LocationPermission.denied) {
    checkdePermission = await Geolocator.requestPermission();
    if (checkdePermission == LocationPermission.denied) {
      return '위치 권한을 허가해주세요.';
    }
  }
  if (checkdePermission == LocationPermission.deniedForever) {
    return '앱의 위치 권한을 설정에서 허가해주세요.';
  }
  return '위치 권한이 허가 되었습니다.';
}

