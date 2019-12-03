import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location_picker_fluttify/src/ui/widget/nonvisual/auto_close_keyboard.widget.dart';
import 'package:location_picker_fluttify/src/utils/bloc/bloc.dart';
import 'package:location_picker_fluttify/src/utils/bloc/bloc_provider.widget.dart';
import 'package:location_picker_fluttify/src/utils/empty_util.dart';

typedef void _InitAction<T extends BLoC>(T bloc);

/// [B]是指定的BLoC
class DecoratedWidget<B extends BLoC> extends StatefulWidget {
  DecoratedWidget({
    Key key,
    @required this.widget,
    this.bloc,
    this.autoCloseKeyboard = true,
    this.init,
    this.withForm = false,
    this.withDefaultTabController = false,
    this.tabLength,
  })  : assert((B != BLoC && bloc != null) || (B == BLoC && bloc == null)),
        assert((withDefaultTabController && tabLength != null) ||
            !withDefaultTabController),
        super();

  /// 直接传递的BLoC
  final B bloc;

  /// child
  final Widget widget;

  /// 是否自动关闭输入法
  final bool autoCloseKeyboard;

  /// 初始化方法
  final _InitAction<B> init;

  /// 是否带有表单
  final bool withForm;

  /// 是否含有TabBar
  final bool withDefaultTabController;

  /// tab bar长度, 必须和[withDefaultTabController]一起设置
  final int tabLength;

  @override
  _DecoratedWidgetState createState() => _DecoratedWidgetState<B>();
}

class _DecoratedWidgetState<B extends BLoC> extends State<DecoratedWidget<B>> {
  /// 网络状态监听的订阅
  StreamSubscription _subscription;

  @override
  Widget build(BuildContext context) {
    Widget result;
    if (isNotEmpty(widget.bloc)) {
      result = BLoCProvider<B>(
        bloc: widget.bloc,
        init: widget.init,
        child: widget.widget,
      );
    } else {
      result = widget.widget;
    }

    // 是否自动收起键盘
    if (widget.autoCloseKeyboard) {
      result = AutoCloseKeyboard(child: result);
    }

    // 是否带有表单
    if (widget.withForm) {
      result = Form(child: result);
    }

    if (widget.withDefaultTabController) {
      result = DefaultTabController(length: widget.tabLength, child: result);
    }

    return result;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
