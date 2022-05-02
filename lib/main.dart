import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ruo/screens/home/homescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Color(0xFFF2F2F2),
        secondaryHeaderColor: Colors.white,
        backgroundColor: Colors.white,
        hintColor: Colors.black.withOpacity(0.4),
        primaryColor: Colors.green,
        splashColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        brightness: Brightness.light,
        textTheme: const TextTheme(
          bodyText1: TextStyle(),
          headline6: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
