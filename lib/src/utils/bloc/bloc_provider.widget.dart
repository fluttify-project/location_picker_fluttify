import 'package:flutter/material.dart';
import 'package:location_picker_fluttify/src/utils/bloc/bloc.dart';

import '../empty_util.dart';

typedef void _Init<T extends BLoC>(T bloc);

class BLoCProvider<T extends BLoC> extends StatefulWidget {
  BLoCProvider({
    Key key,
    @required this.child,
    @required this.bloc,
    this.init,
    this.onDispose,
  }) : super(key: key);

  final T bloc;
  final _Init<T> init;
  final Widget child;
  final VoidCallback onDispose;

  @override
  _BLoCProviderState<T> createState() => _BLoCProviderState<T>();

  static T of<T extends BLoC>(BuildContext context) {
    final type = _typeOf<_BLoCProviderInherited<T>>();
    _BLoCProviderInherited<T> provider =
        context.ancestorInheritedElementForWidgetOfExactType(type)?.widget;
    return provider?.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BLoCProviderState<T extends BLoC> extends State<BLoCProvider<T>> {
  @override
  void initState() {
    super.initState();

    if (isNotEmpty(widget.init)) widget.init(widget.bloc);
  }

  @override
  Widget build(BuildContext context) {
    return _BLoCProviderInherited(
      child: widget.child,
      bloc: widget.bloc,
    );
  }

  @override
  void reassemble() {
    widget.bloc.reassemble();
    super.reassemble();
  }

  @override
  void dispose() {
    widget.bloc.close();

    if (widget.onDispose != null) {
      widget.onDispose();
    }
    super.dispose();
  }
}

class _BLoCProviderInherited<T> extends InheritedWidget {
  _BLoCProviderInherited({
    Key key,
    @required Widget child,
    @required this.bloc,
  }) : super(key: key, child: child);

  final T bloc;

  @override
  bool updateShouldNotify(_BLoCProviderInherited oldWidget) => false;
}
