import 'package:amap_search_fluttify/amap_search_fluttify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location_picker_fluttify/src/bloc/location_picker.bloc.dart';
import 'package:location_picker_fluttify/src/ui/widget/visual/preferred/preferred_async_builder.widget.dart';
import 'package:location_picker_fluttify/src/utils/bloc/bloc_provider.widget.dart';

import 'location_picker.screen.dart';

class Candidates extends StatelessWidget {
  const Candidates({
    Key key,
    @required this.poiBuilder,
  }) : super(key: key);

  final PoiBuilder poiBuilder;

  @override
  Widget build(BuildContext context) {
    final bloc = BLoCProvider.of<LocationPickerBLoC>(context);
    return PreferredStreamBuilder<List<Poi>>(
      stream: bloc.poiList.stream,
      builder: (data) {
        return ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            return FutureBuilder<Widget>(
              future: poiBuilder(context, data[index]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data;
                } else {
                  return SizedBox.shrink();
                }
              },
            );
          },
          separatorBuilder: (_, __) => Divider(height: 0, indent: 8),
        );
      },
    );
  }
}
