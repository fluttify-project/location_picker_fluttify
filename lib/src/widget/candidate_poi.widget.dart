import 'package:flutter/material.dart';

class CandidatePoi extends StatelessWidget {
  const CandidatePoi({
    Key key,
    this.title,
    this.subtitle,
    this.trailing,
    this.padding = const EdgeInsets.all(8.0),
  }) : super(key: key);

  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[title, subtitle],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
