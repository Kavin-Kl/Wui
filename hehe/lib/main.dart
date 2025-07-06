import 'package:flutter/material.dart';
import 'package:hehe/home.dart';
import 'package:apsl_sun_calc/apsl_sun_calc.dart';
//#dfddd9,rgba(223,221,217,255)backgroundColor: Color(0xFFDFDDD9),
//#ff9400,rgba(255,148,0,255)pointer indicator inner: Color(0xFFFF9400),
//#e6cead,rgba(230,206,173,255)pointer indicator outer: Color(0xFFE6CEAD),
//#050402,rgba(5,4,2,255)pointer dots color: Color(0xFF050402),
//#010000 ,rgba(1,0,0,255)pointer dots alt color: Color(0xFF010000),

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          elevation: 0, // AppBar background color
          titleTextStyle: TextStyle(
            fontFamily: 'Orbitron',
            color: Colors.black, // AppBar title text color
          ),
        ),
        scaffoldBackgroundColor: Color(0xFFDFDDD9), // Background color
        primaryColor: Color(0xFFDFDDD9),
        textTheme: TextTheme(
          bodySmall: TextStyle(
            fontFamily: 'Orbitron',
            color: Color(0xFF050402), // Text color
            fontSize: 14,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Orbitron',
            color: Color(0xFF050402), // Text color
            fontSize: 18,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Orbitron',
            color: Color(0xFF050402), // Text color
            fontSize: 16,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Orbitron',
            color: Color(0xFF050402), // Headline text color
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
