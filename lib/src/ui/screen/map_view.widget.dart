import 'package:after_layout/after_layout.dart';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:amap_search_fluttify/amap_search_fluttify.dart';
import 'package:flutter/widgets.dart';
import 'package:location_picker_fluttify/src/bloc/location_picker.bloc.dart';
import 'package:location_picker_fluttify/src/utils/bloc/bloc_provider.widget.dart';
import 'package:location_picker_fluttify/src/utils/permissions.dart';

class MapView extends StatefulWidget {
  const MapView({Key key, this.maskDelay}) : super(key: key);

  final Duration maskDelay;

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with AfterLayoutMixin, _Private {
  @override
  Widget build(BuildContext context) {
    return AmapView(
      maskDelay: widget.maskDelay,
      showZoomControl: false,
      onMapMoveEnd: _handleMapMoveEnd,
      onMapCreated: _handleCreate,
    );
  }
}

mixin _Private<T extends StatefulWidget> on AfterLayoutMixin<T> {
  AmapController _controller;

  @override
  void afterFirstLayout(BuildContext context) {
    final bloc = BLoCProvider.of<LocationPickerBLoC>(context);
    bloc.locate.listen((_) => _controller?.showMyLocation(true));
  }

  Future<void> _handleCreate(AmapController controller) async {
    _controller = controller;
    if (await requestPermission()) {
      await _controller.showMyLocation(true);
      await _controller.setZoomLevel(15, animated: false);
      await _controller.showLocateControl(false);
      await _handleMapMoveEnd(null);
    }
  }

  Future<void> _handleMapMoveEnd(_) async {
    final bloc = BLoCProvider.of<LocationPickerBLoC>(context);

    bloc.moveEnd.add(Object());

    final center = await _controller.getCenterCoordinate();
    final around = await AmapSearch.searchAround(center);

    Stream.fromIterable(around)
        .asyncMap((poi) => poi)
        .toList()
        .then(bloc.poiList.add);
  }
}
