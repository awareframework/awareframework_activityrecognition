import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_activityrecognition/awareframework_activityrecognition.dart';
import 'package:awareframework_core/awareframework_core.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ActivityRecognitionSensor sensor;
  late ActivityRecognitionSensorConfig config;

  @override
  void initState() {
    super.initState();

    config = ActivityRecognitionSensorConfig()..debug = true;

    sensor = new ActivityRecognitionSensor(config);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin Example App'),
        ),
        body: Text(""),
      ),
    );
  }
}
