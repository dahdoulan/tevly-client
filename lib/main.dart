import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tevly_client/admin_component/pages/admin_dashboard.dart';
import 'package:tevly_client/auth_components/pages/admin_signup.dart';
import 'package:tevly_client/auth_components/pages/filmmaker_signup.dart';
import 'package:tevly_client/auth_components/pages/forgot_password.dart';
import 'package:tevly_client/auth_components/pages/login.dart';
import 'package:tevly_client/auth_components/pages/signup.dart';
import 'package:tevly_client/auth_components/pages/verification_page.dart';
import 'package:tevly_client/auth_components/widgets/launch_screen.dart';
import 'package:tevly_client/home_component/models/theme.dart';
import 'package:tevly_client/home_component/providers/comment_provider.dart';
import 'package:tevly_client/home_component/providers/Rating_provider.dart';
import 'package:tevly_client/home_component/providers/search_provider.dart';
import 'package:tevly_client/home_component/screens/get_started_screen.dart';
import 'package:tevly_client/home_component/screens/payment_screen.dart';
import 'package:tevly_client/home_component/screens/search.dart';
import 'package:tevly_client/home_component/screens/settings.dart';
import 'package:tevly_client/upload_component/pages/upload_page.dart';
import 'package:tevly_client/video_player/pages/videoPlayer.dart';
import 'package:tevly_client/video_player/providers/videoPlayer_provider.dart';
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
        ChangeNotifierProvider(create: (_) => VideoProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()), 
      ],
      builder: (context, child) => const MyApp(),
    ),
  );
}
Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/video-player':
      final args = settings.arguments as Map<String, dynamic>;
      final id = args['id'] as int;  // Ensure we're getting an int
      return MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(movieId: id),
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
            seedColor: AppTheme.primaryColor, brightness: Brightness.dark),
      ),

 home :const LaunchScreen(),
      routes: {
        '/signup': (context) =>  SignupPage(),
        '/login': (context) => const LoginPage(),
        '/upload': (context) => const UploadPage(),
        '/home': (context) => const HomeScreen(),
        '/verification': (context) => const VerificationPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/signupFilmmaker': (context) => FilmmakerSignupPage(),
        '/admin': (context) => const AdminDashboard(),
        '/settings': (context) => const SettingsPage(),
        '/search': (context) => const MovieSearchPage(),
        '/getstarted': (context) => const GetStartedScreen(),
        '/payment': (context) => const PaymentScreen(), 
        '/adminSignup': (context) => AdminSignupPage(),
         },
          onGenerateRoute: _onGenerateRoute,
   
    );
  }
}
