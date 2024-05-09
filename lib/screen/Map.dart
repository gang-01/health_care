import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:health/screen/HomeScreen.dart';

class map extends StatefulWidget{
  @override
  _map createState() => _map();
}

class _map extends State<map> {
  late GoogleMapController mapController;
  late LatLng currentLocation;

  @override
  void initState(){
    super.initState();
    _getCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _getCurrentLocation() async{
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
    setState((){
      currentLocation= LatLng(position.latitude,position.longitude);
    });
  }

  //지도 초기화 위치
  static final LatLng companyLatLng = LatLng(
    37.5233273, //위도
    126.921252,  //경도
  );

  //약국 위치 마커 선언
  static final Marker marker = Marker(
    markerId: MarkerId('medicine'), //travel -> medicine으로 바꿈
    position: companyLatLng,
  );

  //현재 위치 반경 표시
  static final Circle circle = Circle(
    circleId: CircleId('CheckCircle'),
    center: companyLatLng,  //원의 중심이 되는 위치. (LatLng값 제공)
    fillColor: Colors.blue.withOpacity(0.5),
    radius: 100,
    strokeColor: Colors.blue,
    strokeWidth: 1,
  );

  //const map({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: renderAppBar(),
        body: FutureBuilder<String>(
            future: checkPermission(),
            builder: (context, snapshot) {
              if (!snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data == '위치 권한이 허가 되었습니다.') {
                return Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: currentLocation,
                          zoom: 16,
                        ),
                        myLocationEnabled: true, //내 위치를 지도에 보여주기
                        markers: Set<Marker>.of((currentLocation != null)
                            ?[
                              Marker(
                                markerId: MarkerId('current_location'),
                                position: currentLocation,
                                infoWindow: InfoWindow(title: "현재위치"),
                              )
                        ]:[]),
                        //circles: Set.from([circle]),
                      ),
                    ),
                    Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.timelapse_outlined,color: Colors.green,size: 50.0,),
                            const SizedBox(height: 10.0),
                            ElevatedButton(
                                onPressed: () async{
                                  print(currentLocation.latitude);
                                  print(currentLocation.longitude);
                                },
                                child: Text('현재위치 불러오기!'))
                          ],
                        ))
                  ],
                );
              }
              return Center(
                child: Text(
                  snapshot.data.toString(),
                ),
              );
            }
        )
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

