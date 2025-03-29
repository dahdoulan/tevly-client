import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tevly_client/auth_components/pages/login.dart';
import 'package:tevly_client/auth_components/pages/signup.dart';
import 'package:tevly_client/upload_component/pages/upload_page.dart';

import 'upload_component/providers/video_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VideoUploadProvider()),
      ],
      builder: (context, child) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.yellow, brightness: Brightness.dark),
      ),
      home: SignupPage(),
      routes: {
        // '/forgot-password': (context) => ForgotPasswordPage(),
        '/signup': (context) => SignupPage(),
        '/login': (context) => LoginPage(),
        '/upload': (context) => const UploadPage(),
        // '/home': (context) => HomePage(),
      },
    );
  }
}
