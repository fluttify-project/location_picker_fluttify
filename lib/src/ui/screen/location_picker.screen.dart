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

class _LocationPickerScreenState extends State<LocationPickerScreen>
    with SingleTickerProviderStateMixin {
  AmapController _controller;
  Future<List<Poi>> _poiList = Future.value([]);

  AnimationController _jumpController;
  Animation<Offset> _tween;

  @override
  void initState() {
    super.initState();
    _jumpController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _tween = Tween(begin: Offset(0, 0), end: Offset(0, -15)).animate(
        CurvedAnimation(parent: _jumpController, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Stack(
              children: <Widget>[
                AmapView(
                  maskDelay: widget.maskDelay,
                  showZoomControl: false,
                  onMapMoveStart: _handleMapMoveStart,
                  onMapMoveEnd: _handleMapMoveEnd,
                  onMapCreated: _handleCreate,
                ),
                Center(
                  child: AnimatedBuilder(
                    animation: _tween,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          _tween.value.dx,
                          _tween.value.dy - _iconSize / 2,
                        ),
                        child: child,
                      );
                    },
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
            child: _Candidates(
              poiList: _poiList,
              poiBuilder: widget.poiBuilder,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCreate(controller) async {
    _controller = controller;
    if (await requestPermission()) {
      await _controller.showMyLocation(true);
      await _controller.setZoomLevel(15, animated: false);
      await _controller.showLocateControl(false);
      await _handleMapMoveEnd(null);
    }
  }

  Future<void> _handleMapMoveStart(MapMove move) async {}

  Future<void> _handleMapMoveEnd(_) async {
    // 执行跳动动画
    _jumpController.forward().then((it) => _jumpController.reverse());

    final center = await _controller.getCenterCoordinate();
    final around = await AmapSearch.searchAround(center);

    setState(() {
      _poiList = Stream.fromIterable(around).asyncMap((poi) => poi).toList();
    });
  }

  Future<void> _handleLocate() async {
    _controller.showMyLocation(true);
  }
}

class _Candidates extends StatelessWidget {
  const _Candidates({
    Key key,
    @required this.poiList,
    @required this.poiBuilder,
  }) : super(key: key);

  final Future<List<Poi>> poiList;
  final PoiBuilder poiBuilder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Poi>>(
      future: poiList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return FutureBuilder<Widget>(
                future: poiBuilder(context, snapshot.data[index]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data;
                  } else {
                    return Center(child: CupertinoActivityIndicator());
                  }
                },
              );
            },
            separatorBuilder: (_, __) => Divider(height: 0, indent: 8),
          );
        } else {
          return Center(child: CupertinoActivityIndicator());
        }
      },
    );
  }
}
