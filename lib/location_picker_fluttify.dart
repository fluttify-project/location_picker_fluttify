import 'dart:async';

import 'package:flutter/services.dart';

class LocationPickerFluttify {
  static const MethodChannel _channel =
      const MethodChannel('location_picker_fluttify');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
