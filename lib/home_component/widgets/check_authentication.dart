import 'package:flutter/material.dart';
import 'package:tevly_client/auth_components/service/authenticationService.dart';

class CheckAuthentication extends StatefulWidget {
  final Widget child;

  const CheckAuthentication({Key? key, required this.child}) : super(key: key);

  @override
  State<CheckAuthentication> createState() => _CheckAuthenticationState();
}

class _CheckAuthenticationState extends State<CheckAuthentication> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  void _checkAuthentication() async {
    final token = await AuthenticationService().getToken();
    if (token == null) {
      // Redirect to login if no token
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
