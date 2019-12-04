import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:location_picker_fluttify/src/bloc/location_picker.bloc.dart';
import 'package:location_picker_fluttify/src/utils/bloc/bloc_provider.widget.dart';
import 'package:location_picker_fluttify/src/utils/objects.dart';

const _iconSize = 50.0;

class Pointer extends StatefulWidget {
  const Pointer({
    Key key,
    @required this.pointer,
  }) : super(key: key);

  final Widget pointer;

  @override
  _PointerState createState() => _PointerState();
}

class _PointerState extends State<Pointer>
    with SingleTickerProviderStateMixin, AfterLayoutMixin {
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
  void afterFirstLayout(BuildContext context) {
    final bloc = BLoCProvider.of<LocationPickerBLoC>(context);
    bloc.moveEnd.listen((_) {
      // 执行跳动动画
      _jumpController.forward().then((it) => _jumpController.reverse());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
        child: widget.pointer ?? gDefaultPointer,
      ),
    );
  }
}
