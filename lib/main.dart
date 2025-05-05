import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tevly_client/auth_components/pages/forgotPassword.dart';
import 'package:tevly_client/auth_components/pages/login.dart';
import 'package:tevly_client/auth_components/pages/signup.dart';
import 'package:tevly_client/auth_components/pages/verificationPage.dart';
import 'package:tevly_client/home_component/models/movie.dart';
import 'package:tevly_client/home_component/providers/Comment_provider.dart';
import 'package:tevly_client/upload_component/pages/upload_page.dart';
import 'package:tevly_client/video_player/videoPlayer.dart';
import 'upload_component/providers/video_provider.dart';
import 'home_component/providers/movie_provider.dart';
import 'home_component/screens/home_screen.dart';
import 'home_component/screens/movie_details_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        ChangeNotifierProvider(create: (_) => VideoUploadProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
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
      title: 'Tvely',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.yellow, brightness: Brightness.dark),
      ),
      home: LoginPage(),
      routes: {
        '/signup': (context) => SignupPage(),
        '/login': (context) => LoginPage(),
        '/upload': (context) => const UploadPage(),
        '/home': (context) => HomeScreen(),
        '/verification': (context) => VerificationPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/video-player') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => UniversalVideoPlayer(
              resolutionUrls: args['resolutionUrls'] as Map<String, String>,
            ),
          );
        }
        return null;
      },
      initialRoute: '/login',
    );
  }
}
