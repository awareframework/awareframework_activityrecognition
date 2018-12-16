import 'package:flutter/material.dart';
import 'package:awareframework_activityrecognition/awareframework_activityrecognition.dart';
import 'package:awareframework_core/awareframework_core.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  ActivityRecognitionSensor sensor;
  ActivityRecognitionSensorConfig config;

  @override
  void initState() {
    super.initState();

    config = ActivityRecognitionSensorConfig()
      ..debug = true
      ..dbType = DatabaseType.DEFAULT
      ..dbHost = "node.awareframework.com:1001";
    sensor = new ActivityRecognitionSensor.init(config);
    sensor.start();
  }

  void _updateSensor(){
    sensor.sync(force: true);
  }

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: const Text('Plugin Example App'),
          ),
          body: new ActivityRecognitionCard(sensor: sensor,),
          floatingActionButton: new FloatingActionButton(
            onPressed: _updateSensor,
            tooltip: 'Refresh',
            child: new Icon(Icons.sync),
          ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
