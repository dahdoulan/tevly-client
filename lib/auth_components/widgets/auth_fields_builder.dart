import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tevly_client/home_component/models/theme.dart';

class LoginForm extends StatefulWidget {
  final Function(String email, String password) onSubmit;
  final bool isLoading;

  const LoginForm({
    Key? key,
    required this.onSubmit,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField(_emailController, "Email", Icons.email_outlined, false),
        const SizedBox(height: 20),
        _buildTextField(_passwordController, "Password", Icons.lock_outline, true),
        const SizedBox(height: 10),
       // _buildForgotPasswordButton(),
        const SizedBox(height: 20),
        _buildLoginButton(),
      ],
    );
  }
Widget _buildLoginButton() {
    return SizedBox(
    width: kIsWeb
        ? MediaQuery.of(context).size.width * 0.4
        : MediaQuery.of(context).size.width * 0.8,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.defaultPadding),
      child: ElevatedButton(
        onPressed: widget.isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: AppTheme.textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: widget.isLoading
            ? AppTheme.loadingIndicator
            : Text('Login', style: AppTheme.headerStyle),
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
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$');
  String? getErrorText(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    switch (hintText) {
      case "Email":
        if (!emailRegex.hasMatch(value)) {
          return 'Enter a valid email address';
        }
        break;
      case "Password":
        if (!passwordRegex.hasMatch(value)) {
          return 'Min 8 chars, 1 uppercase, 1 symbol';
        }
        break;
      
      
    }
    return null;
  }
     return Container(
    width: kIsWeb
        ? MediaQuery.of(context).size.width * 0.4
        : MediaQuery.of(context).size.width * 0.8,
    padding: EdgeInsets.symmetric(horizontal: AppTheme.defaultPadding),
    child: TextFormField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      validator: (value) => getErrorText(value),
      style: AppTheme.bodyStyle,
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
  void _login() {
    widget.onSubmit(_emailController.text, _passwordController.text);
  }
}