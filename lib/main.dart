import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tevly_client/auth_components/pages/login.dart';
import 'package:tevly_client/auth_components/pages/signup.dart';
import 'package:tevly_client/upload_component/pages/upload_page.dart';
import 'package:tevly_client/video_player/videoPlayer.dart';
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
      title: 'Tvely',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.yellow, brightness: Brightness.dark),
      ),
home:  const UniversalVideoPlayer(
  resolutionUrls: {
    '1080p': 'https://videos.pexels.com/video-files/29581749/12732628_2560_1440_30fps.mp4',
    '720p': 'https://videos.pexels.com/video-files/31525181/13437831_1920_1080_25fps.mp4',
    '480p': 'https://videos.pexels.com/video-files/31596733/13463831_1080_1920_60fps.mp4',
  }, 
),
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
