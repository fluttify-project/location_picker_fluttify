library location_picker_fluttify;

import 'package:amap_search_fluttify/amap_search_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:location_picker_fluttify/src/bloc/location_picker.bloc.dart';
import 'package:location_picker_fluttify/src/ui/route/decorated_route.route.dart';

import 'src/ui/screen/location_picker.screen.dart';

export 'package:amap_map_fluttify/amap_map_fluttify.dart';
export 'package:amap_search_fluttify/amap_search_fluttify.dart';

Future<Poi> showLocationPicker(
  BuildContext context, {
  @required PoiBuilder poiBuilder,
  Widget center,
  Widget locate,
  AlignmentGeometry locateAlignment = AlignmentDirectional.bottomEnd,
  Duration maskDelay = const Duration(milliseconds: 800),
}) {
  return Navigator.push(
    context,
    DecoratedRoute<LocationPickerBLoC, Poi>(
      bloc: LocationPickerBLoC(),
      screen: LocationPickerScreen(
        poiBuilder: poiBuilder,
        center: center,
        locate: locate,
        locateAlignment: locateAlignment,
        maskDelay: maskDelay,
      ),
    ),
  );
}
