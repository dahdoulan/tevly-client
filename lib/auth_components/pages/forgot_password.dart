import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:tevly_client/auth_components/api/api_constants.dart';
import 'package:tevly_client/home_component/models/theme.dart';
import '../../commons/logger/logger.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;
  bool _isPasswordVisible = false;
  String? _errorMessage;

  Future<void> _sendResetEmail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.forgotPassword),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text.trim(),
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          _emailSent = true;
          _errorMessage = null;
        });
      } else {
        setState(() {
          _errorMessage = 'Email not found. Please try again.';
        });
      }
    } catch (e) {
      Logger.debug('Password reset error: $e');
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resetPassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.forgotPassword),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text.trim(),
          'password': _newPasswordController.text,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        setState(() {
          _errorMessage = 'Password reset failed. Please try again.';
        });
      }
    } catch (e) {
      Logger.debug('Password reset error: $e');
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
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
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
                ),
                const SizedBox(height: 30),
                Text(
                  _emailSent ? 'Reset Password' : 'Forgot Password',
                         style: AppTheme.headerStyle,
                ),
                const SizedBox(height: 20),
                if (!_emailSent) ...[
                  _buildTextField(
                    _emailController,
                    "Email",
                    Icons.email_outlined,
                    false,
                  ),
                  const SizedBox(height: 30),
                  _buildActionButton(_sendResetEmail, 'Send Reset Email'),
                ] else ...[
                  _buildTextField(
                    _newPasswordController,
                    "New Password",
                    Icons.lock_outline,
                    true,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    _confirmPasswordController,
                    "Confirm Password",
                    Icons.lock_outline,
                    true,
                  ),
                  const SizedBox(height: 30),
                  _buildActionButton(_resetPassword, 'Reset Password'),
                ],
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                 TextButton(
      onPressed: () => Navigator.pushNamed(context, '/login'),
      child: Text(
        "Back to Login",
        style: AppTheme.linkStyle,
      ),
    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hintText,
    IconData icon,
    bool isPassword,
  ) {
    return Container(
    width: kIsWeb
        ? MediaQuery.of(context).size.width * 0.4
        : MediaQuery.of(context).size.width * 0.8,
    padding: EdgeInsets.symmetric(horizontal: AppTheme.defaultPadding),
    child: TextFormField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      style: AppTheme.bodyStyle,
      autovalidateMode: AutovalidateMode.onUserInteraction,
       decoration: AppTheme.inputDecoration.copyWith(
        hintText: hintText,
        hintStyle: AppTheme.captionStyle,
        prefixIcon: Icon(icon, color: AppTheme.textColor),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: AppTheme.textColor,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
      ),
    ),
  );
  }

  Widget _buildActionButton(VoidCallback onPressed, String text) {
    return SizedBox(
    width: kIsWeb
        ? MediaQuery.of(context).size.width * 0.4
        : MediaQuery.of(context).size.width * 0.8,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.defaultPadding),
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,  
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: AppTheme.textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ), child: _isLoading
            ? AppTheme.loadingIndicator
            : Text('Submit', style: AppTheme.headerStyle),
      ),),);
  }
}