import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';

/// This is an Aware Framework plugin for monitoring motion activities.
/// This package allows us to monitor motion activity data such as running,
/// walking, and automotive.
///
/// Your can initialize this class by the following code.
/// ```dart
/// var sensor = ActivityRecognitionSensor();
/// ```
///
/// If you need to initialize the sensor with configurations,
/// you can use the following code instead of the above code.
///
/// ```dart
/// var config =  ActivityRecognitionSensorConfig();
/// config
///   ..debug = true
///
/// var sensor = ActivityRecognitionSensor.init(config);
/// ```
///
/// Each sub class of AwareSensor provides the following method for controlling
/// the sensor:
/// - `start()`
/// - `stop()`
/// - `enable()`
/// - `disable()`
/// - `sync()`
/// - `setLabel(String label)`
///
/// `Stream<ActivityRecognitionData>` allow us to monitor the sensor update
/// events as follows:
///
/// ```dart
/// sensor.onDataChanged.listen((data) {
///   print(data)
/// }
/// ```
///
/// In addition, this package support data visualization function on Cart Widget.
/// You can generate the Cart Widget by following code.
///
/// ```dart
/// var card = ActivityRecognitionCard(sensor: sensor);
/// ```
///
class ActivityRecognitionSensor extends AwareSensor {
  static const MethodChannel _activityRecognitionMethod = const MethodChannel('awareframework_activityrecognition/method');
  static const EventChannel  _activityRecognitionStream  = const EventChannel('awareframework_activityrecognition/event');
  static const EventChannel  _onDataChangedStream  = const EventChannel('awareframework_activityrecognition/event_on_data_changed');

  static StreamController<Map<String,dynamic>> streamController = StreamController<Map<String,dynamic>>();
  Map<String,dynamic> data = Map<String,dynamic>();

  /// Init  ActivityRecognition Sensor without a configuration file
  ///
  /// ```dart
  /// var sensor = ActivityRecognitionSensor();
  /// ```
  ActivityRecognitionSensor():this.init(null);

  /// Init  ActivityRecognition Sensor with  ActivityRecognitionSensorConfig
  ///
  /// ```dart
  /// var config =   ActivityRecognitionSensorConfig();
  /// config
  ///   ..debug = true
  ///   ..frequency = 100;
  ///
  /// var sensor =  ActivityRecognitionSensor.init(config);
  /// ```
  ActivityRecognitionSensor.init(ActivityRecognitionSensorConfig config) : super(config){
    super.setMethodChannel(_activityRecognitionMethod);
  }

  /// An event channel for monitoring sensor events.
  ///
  /// `Stream<Map<String,dynamic>>` allow us to monitor the sensor update
  /// events as follows:
  ///
  /// ```dart
  /// sensor.onDataChanged.listen((data) {
  ///   print(data)
  /// }
  ///
  Stream<Map<String,dynamic>> get onDataChanged {
    streamController.close();
    streamController = StreamController<Map<String,dynamic>>();
    return streamController.stream;
  }

  @override
  Future<Null> start() {
    super.getBroadcastStream(_onDataChangedStream, "on_data_changed").map(
            (dynamic event) => Map<String,dynamic>.from(event)
    ).listen((event){
      data = event;
      if(!streamController.isClosed){
        streamController.add(data);
      }
    });
    return super.start();
  }

  @override
  Future<Null> stop() {
    super.cancelBroadcastStream("on_data_changed");
    return super.stop();
  }

}

/// A configuration class of ActivityRecognitionSensor
///
/// You can initialize the class by following code.
///
/// ```dart
/// var config =  ActivityRecognitionSensorConfig();
/// config
///   ..debug = true
/// ```
class ActivityRecognitionSensorConfig extends AwareSensorConfig{
  ActivityRecognitionSensorConfig();

  // sensing interval (min)
  double interval = 10.0;

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['interval'] = interval;
    return map;
  }
}

///
/// A Card Widget of ActivityRecognition Sensor
///
/// You can generate a Cart Widget by following code.
/// ```dart
/// var card = ActivityRecognitionCard(sensor: sensor);
/// ```
class ActivityRecognitionCard extends StatefulWidget {
  ActivityRecognitionCard({Key key,
                          @required this.sensor,
                          }) : super(key: key);

  final ActivityRecognitionSensor sensor;

  @override
  ActivityRecognitionCardState createState() => new ActivityRecognitionCardState();
}

///
/// A Card State of Accelerometer Sensor
///
class ActivityRecognitionCardState extends State<ActivityRecognitionCard> {

  String activity = "";

  @override
  void initState() {

    super.initState();

    updateContent(widget.sensor.data);

    // set observer
    widget.sensor.onDataChanged.listen((event) {
      if(event!=null){
        DateTime.fromMicrosecondsSinceEpoch(event['timestamp']);
        if(mounted){
          // save data with update view
          setState((){
            updateContent(event);
          });
        }else{
          // just save data as a status
          updateContent(event);
        }
      }
    }, onError: (dynamic error) {
        print('Received error: ${error.message}');
    });
    print(widget.sensor);
  }

  void updateContent(Map<String,dynamic> event){
    activity = event.toString();
  }

  @override
  Widget build(BuildContext context) {
    return new AwareCard(
      contentWidget: SizedBox(
          width: MediaQuery.of(context).size.width*0.8,
          child: new Text(activity),
        ),
      title: "Activity Recognition",
      sensor: widget.sensor
    );
  }

}
