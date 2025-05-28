import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static final primaryColor = Color(0xFAFFD740);
  static final backgroundColor = Colors.black;
  static final surfaceColor = Colors.grey[900];
  static final accentBlue = Colors.blue[700];
  static final accentGreen = Colors.green[700];
  static final accentOrange = Colors.orange[700];
  static final seconderyTextColor = Colors.white;
    // Spacing and Padding
  static const double defaultSpacing = 16.0;
  static const double defaultPadding = 20.0;
  // Additional Colors that match existing palette
  static final secondaryColor = Colors.red[700];
  static const textColor = Colors.white;
  static final textColorSecondary = Colors.grey[500];
  static final borderColor = Colors.grey[800];
  static final errorColor = Colors.red[400];
  
  // Text Styles - keeping existing ones and adding complementary styles
  // ...existing text styles...
 // Text Styles
  static final headerStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
    letterSpacing: 0.5,
  );

  static final subheaderStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textColor,
    letterSpacing: 0.3,
  );
  static final bodyStyle = TextStyle(
    fontSize: 16,
    color: textColor,
    letterSpacing: 0.2,
  );

  static final captionStyle = TextStyle(
    fontSize: 12,
    color: textColorSecondary,
    letterSpacing: 0.4,
  );

  // Container Decoration
  static final containerDecoration = BoxDecoration(
    color: surfaceColor,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: borderColor!,
      width: 1,
    ),
  );

  // Loading Indicator
  static final loadingIndicator = CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
    strokeWidth: 3,
    backgroundColor: surfaceColor,
  );

  static const linkStyle =  TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontWeight: FontWeight.w800,
    decoration: TextDecoration.underline,
    
  );

  static final errorTextStyle = TextStyle(
    fontSize: 14,
    color: errorColor,
    fontWeight: FontWeight.w500,
  );

  // Enhanced Decorations - building upon existing containerDecoration
  static final cardDecoration = BoxDecoration(
    color: surfaceColor,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: borderColor!, width: 1),
  );

  static final inputDecoration = InputDecoration(
    filled: true,
    fillColor: surfaceColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: borderColor!),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: borderColor!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: primaryColor, width: 2),
    ),
  );

  // Button Styles - extending existing elevatedButtonStyle
  static final secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: surfaceColor,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
  );

  // Keeping existing spacing and padding constants
  // ...existing padding & spacing...

  // Animation Durations - useful for consistent animations
  static const Duration quickAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);

  // Responsive Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
}