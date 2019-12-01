library location_picker_fluttify;

import 'package:flutter/material.dart';

import 'src/screen/location_picker.screen.dart';

export 'package:amap_map_fluttify/amap_map_fluttify.dart';
export 'package:amap_search_fluttify/amap_search_fluttify.dart';

export 'src/screen/location_picker.screen.dart';
export 'src/widget/candidate_poi.widget.dart';

Future<void> showLocationPicker(
  BuildContext context, {
  @required PoiBuilder poiBuilder,
  Widget center,
  Widget locate,
  AlignmentGeometry locateAlignment = AlignmentDirectional.bottomEnd,
  Duration maskDelay = const Duration(milliseconds: 800),
}) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => LocationPickerScreen(
        poiBuilder: poiBuilder,
        center: center,
        locate: locate,
        locateAlignment: locateAlignment,
        maskDelay: maskDelay,
      ),
    ),
  );
}
