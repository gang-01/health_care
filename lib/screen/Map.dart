import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class map extends StatelessWidget {
  static final LatLng companyLatLng = LatLng(
    37.5233273,
    126.921252,
  );
  static final Marker marker = Marker(
    markerId: MarkerId('medicine'), //travel -> medicine으로 바꿈
    position: companyLatLng,
  );

  const map({Key? key}) : super(key: key);

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
                        initialCameraPosition: CameraPosition(
                          target: companyLatLng,
                          zoom: 16,
                        ),
                        myLocationEnabled: true,
                        markers: Set.from([marker]),
                      ),
                    ),
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
      'HEALTH',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
    ),
    backgroundColor: Colors.lightGreen,
  );
}

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