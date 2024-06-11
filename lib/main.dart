import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health/screen/HomeScreen.dart';
import 'package:health/screen/Login.dart';
import 'package:health/screen/Map.dart';
//import 'package:health/screen/Map_screen.dart';
import 'package:health/screen/loading.dart';
import'package:firebase_core/firebase_core.dart';
import 'package:health/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health/screen/Weather_Screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
      MaterialApp(
        theme: ThemeData(fontFamily: 'NanumGothic'),
        locale: Locale('ko','KR'),
        supportedLocales: [
          const Locale('en','US'),
          const Locale('ko','KR'),
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        home:  StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomeScreen();
            }
            return LoginSignupScreen();
          },
        ),
      )
  );


  //firebase 프젝 설정
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
