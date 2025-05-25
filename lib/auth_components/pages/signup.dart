import 'package:flutter/material.dart';
import 'package:tevly_client/auth_components/service/signup_service.dart';
import 'package:tevly_client/auth_components/widgets/signup_form.dart';
import 'package:tevly_client/home_component/models/theme.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _signupService = SignupService();
  bool _isLoading = false;

  Future<void> _handleSignup(String firstname, String lastname, String email, 
    String password, String phone, DateTime? birthdate) async {
    setState(() => _isLoading = true);

    final result = await _signupService.signup(
      firstname: firstname,
      lastname: lastname,
      email: email,
      password: password,
      dateOfBirth: birthdate,
      phone: phone,
    );

    setState(() => _isLoading = false);

    if (result['success']) {
      Navigator.pushReplacementNamed(context, '/verification');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message']))
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message']))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor,
              AppTheme.surfaceColor!,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                const SizedBox(height: 30),
                SignupForm(
                  onSubmit: _handleSignup,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 20),
                _buildLoginLink(),
                _buildFilmmakerSignupLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
 

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          'lib/assets/logo.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return TextButton(
      onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
      child: Text(
        "Already have an account? Login",
        style: AppTheme.captionStyle.copyWith(color: AppTheme.textColor),
      ),
    );
  }

  Widget _buildFilmmakerSignupLink() {
    return TextButton(
      onPressed: () => Navigator.pushReplacementNamed(context, '/signupFilmmaker'),
      child: Text(
        "Are you a filmmaker? Sign up here",
        style: AppTheme.captionStyle.copyWith(color: AppTheme.textColor),
      ),
    );
  }
}
