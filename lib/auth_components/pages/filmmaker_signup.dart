import 'package:flutter/material.dart';
import 'package:tevly_client/auth_components/service/signup_service.dart';
import 'package:tevly_client/auth_components/widgets/signup_form.dart';
import 'package:tevly_client/home_component/models/theme.dart';

class FilmmakerSignupPage extends StatefulWidget {
  @override
  _FilmmakerSignupPageState createState() => _FilmmakerSignupPageState();
}

class _FilmmakerSignupPageState extends State<FilmmakerSignupPage> {
  final _signupService = FilmmakerSignupService();
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
      appBar: AppBar(
        title: Text(
          'Filmmaker Signup',
          style: AppTheme.headerStyle.copyWith(color: AppTheme.textColor),
        ),
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
   
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor,
              AppTheme.backgroundColor,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                const SizedBox(height: 20),
                SignupForm(
                  onSubmit: _handleSignup,
                  isLoading: _isLoading,
                ),
           
                _buildLoginLink(),
                const SizedBox(height: 20),],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: AppTheme.bodyStyle,
        ),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/login'),
          child: Text(
            "Login",
            style: AppTheme.linkStyle,
          ),
        ),
      ],
    );
  }

   

}
