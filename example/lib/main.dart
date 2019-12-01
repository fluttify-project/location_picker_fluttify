import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location_picker_fluttify/location_picker_fluttify.dart';

Future<void> main() async {
  await enableFluttifyLog(false);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            onPressed: () => _handleShowPicker(context),
            child: Text('地址选择器'),
          ),
          if (_title != null) Text(_title, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Future<void> _handleShowPicker(BuildContext context) async {
    final poi = await showLocationPicker(
      context,
      poiBuilder: (context, poi) async {
        return CandidatePoi(
          onTap: () => Navigator.pop(context, poi),
          title: Text(
            await poi.title,
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          subtitle: Text(
            await poi.address,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
    poi.title.then((title) => setState(() => _title = title));
  }
}
