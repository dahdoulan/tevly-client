import 'package:flutter/material.dart';
import 'package:tevly_client/pages/login.dart';
import 'package:tevly_client/pages/signup.dart';

 
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow, brightness: Brightness.dark),
      ),
      home: LoginPage (),
      routes: {
        // '/forgot-password': (context) => ForgotPasswordPage(),
         '/signup': (context) => SignupPage(),
         '/login' : (context) => LoginPage(),
        // '/home': (context) => HomePage(),
      },
    );
  }
}