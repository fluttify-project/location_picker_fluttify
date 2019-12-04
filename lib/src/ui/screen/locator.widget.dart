import 'package:flutter/material.dart';
import 'package:location_picker_fluttify/src/bloc/location_picker.bloc.dart';
import 'package:location_picker_fluttify/src/utils/bloc/bloc_provider.widget.dart';
import 'package:location_picker_fluttify/src/utils/objects.dart';

class Locator extends StatelessWidget {
  const Locator({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child ?? gDefaultShowMyLocation,
      onTap: () => _handleLocate(context),
    );
  }

  Future<void> _handleLocate(BuildContext context) async {
    final bloc = BLoCProvider.of<LocationPickerBLoC>(context);
    bloc.locate.add(Object());
  }
}
