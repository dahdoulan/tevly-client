import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:tevly_client/auth_components/api/api_constants.dart';
import 'package:tevly_client/auth_components/service/authenticationService.dart';
import 'package:tevly_client/home_component/models/theme.dart';
import '../../commons/logger/logger.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _verificationController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String text="";

Future<void> _verifyCode() async {
  setState(() {
    _isLoading = true;
    _errorMessage = null;
   });

   try {
     final url = Uri.parse(ApiConstants.verifyEmail).replace(queryParameters: {
      'token': _verificationController.text,}); 
     final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'token': _verificationController.text.trim(),
        
      }),
    );
    if (!mounted) return;
    Logger.debug(response.body.toString());
    if (response.statusCode == 200) {
     const SnackBar(
        content: Text('Verification successful!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      );
      Logger.debug(response.statusCode.toString());
      if(AuthenticationService().getRole()=="ADMIN"){
        Navigator.pushReplacementNamed(context, '/admin');
      }
      else
      {      
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      setState(() {
        _errorMessage = 'Invalid verification code. Please try again.';
        Logger.debug(response.statusCode.toString());
 
      });
    }
  } catch (e) {
    setState(() {
      _errorMessage = 'An error occurred. Please try again.';
    });
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
  @override
  void dispose() {
    _verificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Icon(
                  Icons.email_outlined,
                  size: 100,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                const SizedBox(height: 30),
                Text(
                  'Verify Your Email',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Please enter the verification code sent to your email',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                _buildTextField(),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                _buildVerifyButton("Verify"),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // Add resend verification code logic here
                  },
                  child: Text(
                    'Resend Code',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
          ),
        _buildGoBackToSignupLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      width: kIsWeb
          ? MediaQuery.of(context).size.width * 0.4
          : MediaQuery.of(context).size.width * 0.8,
    padding: EdgeInsets.symmetric(horizontal: AppTheme.defaultPadding),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: _verificationController,
          style: AppTheme.bodyStyle,
            decoration: AppTheme.inputDecoration.copyWith(    
            hintText: 'Enter verification code',
            hintStyle: AppTheme.captionStyle,

          prefixIcon: const Icon(
            Icons.lock_outline,
                  color: AppTheme.textColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyButton(String text) {
    return SizedBox(
      width: kIsWeb
          ? MediaQuery.of(context).size.width * 0.4
          : MediaQuery.of(context).size.width * 0.8,
      child: Padding(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.defaultPadding),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _verifyCode,
         style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: AppTheme.textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
          child: _isLoading
              ? const CircularProgressIndicator()
              : Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
        ),
      ),
    );
  }
   Widget _buildGoBackToSignupLink() {
   return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Something wrong? ",
          style: AppTheme.bodyStyle,
        ),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/signup'),
          child: Text(
            "Go back to signup",
            style: AppTheme.linkStyle,
          ),
        ),
      ],
    );
  }
}