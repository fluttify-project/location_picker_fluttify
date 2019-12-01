import 'package:flutter/material.dart';

class CandidatePoi extends StatelessWidget {
  const CandidatePoi({
    Key key,
    @required this.title,
    @required this.subtitle,
    this.trailing,
    this.padding = const EdgeInsets.all(8.0),
    this.onTap,
  }) : super(key: key);

  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final EdgeInsets padding;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
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
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}
