import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tevly_client/home_component/models/theme.dart';
 
class SignupForm extends StatefulWidget {
  final Function(String firstname, String lastname, String email, 
    String password,  DateTime? birthdate) onSubmit;
  final bool isLoading;

  const SignupForm({
    Key? key,
    required this.onSubmit,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  DateTime? _selectedBirthdate;
  bool _isPasswordVisible = false;

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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField(_firstnameController, "First Name", Icons.person_outline, false),
        const SizedBox(height: 10),
        _buildTextField(_lastnameController, "Last Name", Icons.person_outline, false),
        const SizedBox(height: 10),
        _buildTextField(_emailController, "Email", Icons.email_outlined, false),
        const SizedBox(height: 10),
        _buildTextField(_passwordController, "Password", Icons.lock_outline, true),
        const SizedBox(height: 10),
        _buildTextField(_confirmPasswordController, "Confirm Password", Icons.lock_outline, true),
        const SizedBox(height: 10),
         _buildDatePicker(),
        const SizedBox(height: 10),
        _buildLoginButton(),
        const SizedBox(height: 10),
      ],
    );
  }
  
  
   void _submitForm() {
    widget.onSubmit(_firstnameController.text,   _lastnameController.text,_emailController.text, _passwordController.text, _selectedBirthdate);
  }
  Widget _buildLoginButton() {
    return SizedBox(
    width: kIsWeb
        ? MediaQuery.of(context).size.width * 0.4
        : MediaQuery.of(context).size.width * 0.8,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.defaultPadding),
      child: ElevatedButton(
        onPressed: widget.isLoading ? null :  _submitForm,
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
            : Text('Sign Up', style: AppTheme.headerStyle),
      ),
    ),
  );
}


Widget _buildDatePicker() {
  return Container(
    width: kIsWeb
        ? MediaQuery.of(context).size.width * 0.4
        : MediaQuery.of(context).size.width * 0.8,
    padding: EdgeInsets.symmetric(horizontal: AppTheme.defaultPadding),
    child: GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedBirthdate ?? DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null && picked != _selectedBirthdate) {
          setState(() {
            _selectedBirthdate = picked;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: AppTheme.containerDecoration,
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: AppTheme.textColor),
            const SizedBox(width: 10),
            Text(
              _selectedBirthdate == null
                  ? 'Select Birthdate'
                  : '${_selectedBirthdate!.day}/${_selectedBirthdate!.month}/${_selectedBirthdate!.year}',
              style: AppTheme.bodyStyle,
            ),
          ],
        ),
      ),
    ),
  );
}
}