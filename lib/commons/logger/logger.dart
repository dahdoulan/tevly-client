import 'dart:developer';

import 'package:tevly_client/commons/constants/ansi_constants.dart';

class Logger {
  static void debug(String message) {
    log('$green Debug: $message $reset', level: 500);
  }

  static void info(String message) {
    log('$blue Info: $message $reset', level: 800);
  }

  static void warning(String message) {
    log('$yellow Warning: $message $reset', level: 900);
  }

  static void error(String message) {
    log('$red ERROR:  $message $reset', level: 1000);
  }

  static void critical(String message) {
    log('$red CRITICAL:  $message $reset', level: 1200);
  }

  static void fatal(String message) {
    log('$red FATAL:  $message $reset', level: 2000);
  }
}
