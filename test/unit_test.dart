import 'package:test/test.dart';

import 'package:awareframework_activityrecognition/awareframework_activityrecognition.dart';

void main(){
  test("test sensor config", (){
    var config = ActivityRecognitionSensorConfig();
    expect(config.interval, 10.0);

    config.interval = 15.0;
    expect(config.interval, 15.0);

    var mapConfig = config.toMap();
    expect(mapConfig["interval"], 15.0);
  });
}
