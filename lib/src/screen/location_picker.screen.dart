import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:amap_search_fluttify/amap_search_fluttify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location_picker_fluttify/src/utils/objects.dart';
import 'package:location_picker_fluttify/src/utils/permissions.dart';

typedef Future<Widget> PoiBuilder(BuildContext context, Poi poi);

const _iconSize = 50.0;

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({
    Key key,
    this.center,
    this.locate,
    this.locateAlignment = AlignmentDirectional.bottomEnd,
    this.maskDelay = const Duration(milliseconds: 800),
    @required this.poiBuilder,
  }) : super(key: key);

  final Widget center;
  final Widget locate;
  final AlignmentGeometry locateAlignment;
  final Duration maskDelay;
  final PoiBuilder poiBuilder;

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  AmapController _controller;
  List<Poi> _poiList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
            child: Stack(
              children: <Widget>[
                AmapView(
                  maskDelay: widget.maskDelay,
                  showZoomControl: false,
                  onMapDrag: _handleDrag,
                  onMapCreated: _handleCreate,
                ),
                Center(
                  child: Transform.translate(
                    offset: Offset(0, -_iconSize / 2),
                    child: widget.center ?? gDefaultCenter,
                  ),
                ),
                Align(
                  alignment: widget.locateAlignment,
                  child: GestureDetector(
                    child: widget.locate ?? gDefaultShowMyLocation,
                    onTap: _handleLocate,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: _poiList.length,
              itemBuilder: (context, index) {
                return FutureBuilder<Widget>(
                  future: widget.poiBuilder(context, _poiList[index]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data;
                    } else {
                      return Center(child: CupertinoActivityIndicator());
                    }
                  },
                );
              },
              separatorBuilder: (context, index) => Divider(
                height: 0,
                indent: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDrag(drag) async {
    final center = await _controller.getCenterCoordinate();
    final around = await AmapSearch.searchAround(center);

    Stream.fromIterable(around)
        .asyncMap((poi) => poi)
        .toList()
        .then((it) => setState(() => _poiList = it));
  }

  Future<void> _handleCreate(controller) async {
    _controller = controller;
    if (await requestPermission()) {
      await _controller.showMyLocation(true);
      await _controller.setZoomLevel(15, animated: false);
      await _controller.showLocateControl(false);
    }
  }

  Future<void> _handleLocate() async {
    _controller.showMyLocation(true);
  }
}
