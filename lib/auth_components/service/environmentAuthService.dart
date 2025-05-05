import 'dart:io';

import 'package:flutter/foundation.dart';

class Environment {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080/api';
    } 

    //TODO: Change these URLs once we deploy the backend to a CDN
    else {
      if (Platform.isAndroid) {
        return 'http://localhost:8080/api'; // Android emulator localhost
      } else if (Platform.isIOS) {
        return 'http://localhost:8080/api'; // iOS simulator localhost
      } else if (Platform.isWindows) {
        return 'http://localhost:8080/api'; // Windows localhost
      } else {
        return 'http://localhost:8080/api'; // Default for other platforms
      }
    }
  }
}