import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';

/// init sensor
class ActivityRecognitionSensor extends AwareSensorCore {
  static const MethodChannel _activityRecognitionMethod = const MethodChannel('awareframework_activityrecognition/method');
  static const EventChannel  _activityRecognitionStream  = const EventChannel('awareframework_activityrecognition/event');

  /// Init Activityrecognition Sensor with ActivityrecognitionSensorConfig
  ActivityRecognitionSensor(ActivityrecognitionSensorConfig config):this.convenience(config);
  ActivityRecognitionSensor.convenience(config) : super(config){
    /// Set sensor method & event channels
    super.setMethodChannel(_activityRecognitionMethod);
  }

  /// A sensor observer instance
  Stream<Map<String,dynamic>> onDataChanged(String id) {
     return super.getBroadcastStream(_activityRecognitionStream, "on_data_changed", id).map((dynamic event) => Map<String,dynamic>.from(event));
  }
}

class ActivityrecognitionSensorConfig extends AwareSensorConfig{
  ActivityrecognitionSensorConfig();

  // sensing interval (min)
  double interval = 10.0;

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['interval'] = interval;
    return map;
  }
}

/// Make an AwareWidget
class ActivityRecognitionCard extends StatefulWidget {
  ActivityRecognitionCard({Key key,
                          @required this.sensor,
                                    this.cardId="activity_recognition_card",

                          }) : super(key: key);

  ActivityRecognitionSensor sensor;
  String cardId;

  @override
  ActivityRecognitionCardState createState() => new ActivityRecognitionCardState();
}


class ActivityRecognitionCardState extends State<ActivityRecognitionCard> {

  String activity = "";

  @override
  void initState() {

    super.initState();
    // set observer
    widget.sensor.onDataChanged(widget.cardId).listen((event) {
      setState((){
        if(event!=null){
          DateTime.fromMicrosecondsSinceEpoch(event['timestamp']);
          activity = event.toString();
          print(activity);
        }
      });
    }, onError: (dynamic error) {
        print('Received error: ${error.message}');
    });
    print(widget.sensor);
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

  @override
  void dispose() {
    widget.sensor.cancelBroadcastStream(widget.cardId);
    super.dispose();
  }

}
