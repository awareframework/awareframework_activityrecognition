import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';

/// init sensor
class ActivityRecognitionSensor extends AwareSensorCore {
  static const MethodChannel _activityrecognitionMethod =
      const MethodChannel('awareframework_activityrecognition/method');
  static const EventChannel _onDataChangedStream = const EventChannel(
      'awareframework_activityrecognition/event_on_data_changed');

  /// Init ActivityRecognition Sensor with ActivityRecognitionSensorConfig
  ActivityRecognitionSensor(ActivityRecognitionSensorConfig config)
      : this.convenience(config);
  ActivityRecognitionSensor.convenience(config) : super(config) {
    /// Set sensor method & event channels
    super.setMethodChannel(_activityrecognitionMethod);
  }

  static ActivityRecognitionData data = ActivityRecognitionData();

  static StreamController<ActivityRecognitionData> streamController =
      StreamController<ActivityRecognitionData>();

  ActivityRecognitionSensor.init(ActivityRecognitionSensorConfig config)
      : super(config) {
    super.setMethodChannel(_activityrecognitionMethod);
  }

  /// A sensor observer instance
  Stream<ActivityRecognitionData> get onDataChanged {
    streamController.close();
    streamController = StreamController<ActivityRecognitionData>();
    return streamController.stream;
  }

  @override
  Future<Null> start() {
    // listen data update on sensor itself
    super
        .getBroadcastStream(_onDataChangedStream, "on_data_changed")
        .map((dynamic event) =>
            ActivityRecognitionData.from(Map<String, dynamic>.from(event)))
        .listen((event) {
      data = event;
      if (!streamController.isClosed) {
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

class ActivityRecognitionSensorConfig extends AwareSensorConfig {
  ActivityRecognitionSensorConfig();
  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    return map;
  }
}

class ActivityRecognitionData extends AwareData {
  // TODO

  ActivityRecognitionData() : this.from({});
  ActivityRecognitionData.from(Map<String, dynamic>? data) : super(data ?? {}) {
    if (data != null) {
      // TODO
    }
  }
}
