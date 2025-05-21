import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const primaryColor = Colors.red;
  static final backgroundColor = Colors.black;
  static final surfaceColor = Colors.grey[900];
  static final accentBlue = Colors.blue[700];
  static final accentGreen = Colors.green[700];
  static final accentOrange = Colors.orange[700];
  
  // Text Styles
  static const headerStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 1.2,
  );

  static const subheaderStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static const bodyStyle = TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  static final captionStyle = TextStyle(
    fontSize: 12,
    color: Colors.grey[500],
    letterSpacing: 1,
    fontWeight: FontWeight.w500,
  );

  // Decorations
  static final containerDecoration = BoxDecoration(
    color: surfaceColor,
    borderRadius: BorderRadius.circular(16),
  );

  static final buttonDecoration = BoxDecoration(
    color: surfaceColor,
    borderRadius: BorderRadius.circular(12),
  );

  // Padding & Spacing
  static const defaultPadding = EdgeInsets.all(16.0);
  static const defaultSpacing = 16.0;

  // Button Styles
  static final elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
  );

  // Loading Indicator
  static final loadingIndicator = CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
  );
}