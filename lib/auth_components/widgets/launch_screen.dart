import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstRun();
  }

  Future<void> _checkFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenGetStarted = prefs.getBool('hasSeenGetStarted') ?? false;

    if (hasSeenGetStarted) {
      Navigator.of(context).pushReplacementNamed('/login');
    } else {
      Navigator.of(context).pushReplacementNamed('/getstarted');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a splash/loading indicator while checking
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}