import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';

/// init sensor
class ActivityRecognitionSensor extends AwareSensorCore {
  static const MethodChannel _activityRecognitionMethod = const MethodChannel('awareframework_activityrecognition/method');
  static const EventChannel  _activityRecognitionStream  = const EventChannel('awareframework_activityrecognition/event');

  ActivityRecognitionSensor(ActivityRecognitionSensorConfig config):this.convenience(config);
  ActivityRecognitionSensor.convenience(config) : super(config){
    super.setMethodChannel(_activityRecognitionMethod);
  }

  /// A sensor observer instance
  Stream<Map<String,dynamic>> get onDataChanged {
     return super.getBroadcastStream(_activityRecognitionStream, "on_data_changed").map((dynamic event) => Map<String,dynamic>.from(event));
  }

  @override
  void cancelAllEventChannels() {
    super.cancelBroadcastStream("on_data_changed");
  }
}

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

/// Make an AwareWidget
class ActivityRecognitionCard extends StatefulWidget {
  ActivityRecognitionCard({Key key,
                          @required this.sensor,
                          }) : super(key: key);

  final ActivityRecognitionSensor sensor;

  String activity = "";

  @override
  ActivityRecognitionCardState createState() => new ActivityRecognitionCardState();
}


class ActivityRecognitionCardState extends State<ActivityRecognitionCard> {

  @override
  void initState() {

    super.initState();
    // set observer
    widget.sensor.onDataChanged.listen((event) {
      setState((){
        if(event!=null){
          DateTime.fromMicrosecondsSinceEpoch(event['timestamp']);
          widget.activity = event.toString();
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
          child: new Text(widget.activity),
        ),
      title: "Activity Recognition",
      sensor: widget.sensor
    );
  }

  @override
  void dispose() {
    widget.sensor.cancelAllEventChannels();
    super.dispose();
  }

}
