import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location_picker_fluttify/location_picker_fluttify.dart';

void main() {
  const MethodChannel channel = MethodChannel('location_picker_fluttify');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await LocationPickerFluttify.platformVersion, '42');
  });
}
