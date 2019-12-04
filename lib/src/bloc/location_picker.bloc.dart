import 'package:location_picker_fluttify/location_picker_fluttify.dart';
import 'package:location_picker_fluttify/src/utils/bloc/bloc.dart';
import 'package:location_picker_fluttify/src/utils/bloc/bloc_io.dart';

class LocationPickerBLoC extends LocalBLoC with _ComponentMixin {
  LocationPickerBLoC() : super('位置选择 BLoC');
}

mixin _ComponentMixin on LocalBLoC {
  @override
  List<BaseIO> get disposeBag => [poiList];

  final poiList = ListIO<Poi>(semantics: 'poi列表');

  final moveEnd = IO<Object>(semantics: '地图移动结束');

  final locate = IO<Object>(semantics: '定位');
}
