import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tevly_client/admin_component/pages/adminDashboard.dart';
import 'package:tevly_client/auth_components/pages/filmmakerSignUp.dart';
import 'package:tevly_client/auth_components/pages/forgotPassword.dart';
import 'package:tevly_client/auth_components/pages/login.dart';
import 'package:tevly_client/auth_components/pages/signup.dart';
import 'package:tevly_client/auth_components/pages/verificationPage.dart';
import 'package:tevly_client/home_component/providers/Comment_provider.dart';
import 'package:tevly_client/home_component/providers/Rating_provider.dart';
import 'package:tevly_client/home_component/screens/search.dart';
import 'package:tevly_client/home_component/screens/settings.dart';
import 'package:tevly_client/upload_component/pages/upload_page.dart';
import 'package:tevly_client/video_player/videoPlayer.dart';
import 'upload_component/providers/video_provider.dart';
import 'home_component/providers/movie_provider.dart';
import 'home_component/screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        ChangeNotifierProvider(create: (_) => VideoUploadProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
        ChangeNotifierProvider(create: (_) => RatingProvider()),
      ],
      builder: (context, child) => const MyApp(),
    ),
  );
}

Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/video-player':
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (context) => UniversalVideoPlayer(
          resolutionUrls: args['resolutionUrls'] as Map<String, String>,
        ),
      );
    default:
      return null;
  }
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
        '/home': (context) => const HomeScreen(),
        '/verification': (context) => const VerificationPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/signupFilmmaker': (context) => FilmmakerSignupPage(),
        '/admin': (context) => const AdminDashboard(),
        '/settings': (context) => const SettingsPage(),
        '/search': (context) => const MovieSearchPage(),
      },
      onGenerateRoute: _onGenerateRoute,
      initialRoute: '/login',
    );
  }
}
