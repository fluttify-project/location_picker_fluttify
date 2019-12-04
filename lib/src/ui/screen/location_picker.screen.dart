import 'package:amap_search_fluttify/amap_search_fluttify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location_picker_fluttify/src/ui/screen/locator.widget.dart';

import 'candidates.widget.dart';
import 'map_view.widget.dart';
import 'pointer.widget.dart';

typedef Future<Widget> PoiBuilder(BuildContext context, Poi poi);

class LocationPickerScreen extends StatelessWidget {
  const LocationPickerScreen({
    Key key,
    this.pointer,
    this.locator,
    this.locateAlignment = AlignmentDirectional.bottomEnd,
    this.maskDelay = const Duration(milliseconds: 800),
    @required this.poiBuilder,
  }) : super(key: key);

  final Widget pointer;
  final Widget locator;
  final AlignmentGeometry locateAlignment;
  final Duration maskDelay;
  final PoiBuilder poiBuilder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Stack(
              children: <Widget>[
                MapView(maskDelay: maskDelay),
                Pointer(pointer: pointer),
                Align(
                  alignment: locateAlignment,
                  child: Locator(child: locator),
                ),
              ],
            ),
          ),
          Flexible(
            child: Candidates(poiBuilder: poiBuilder),
          ),
        ],
      ),
    );
  }
}
