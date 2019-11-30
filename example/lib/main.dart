import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location_picker_fluttify/location_picker_fluttify.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LocationPickerScreen(
                  poiBuilder: (context, poi) async => CandidatePoi(
                    title: Text(
                      await poi.title,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    subtitle: Text(
                      await poi.address,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Icon(
                      Icons.check,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            );
          },
          child: Text('地址选择器'),
        ),
      ),
    );
  }
}
