import Flutter
import UIKit
import com_awareframework_ios_sensor_activityrecognition
import com_awareframework_ios_sensor_core
import awareframework_core

public class SwiftAwareframeworkActivityrecognitionPlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorInitializationHandler, ActivityRecognitionObserver{

    public func initializeSensor(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            if let config = call.arguments as? Dictionary<String,Any>{
                self.activityRecognitionSensor = ActivityRecognitionSensor.init(ActivityRecognitionSensor.Config(config))
            }else{
                self.activityRecognitionSensor = ActivityRecognitionSensor.init(ActivityRecognitionSensor.Config())
            }
            self.activityRecognitionSensor?.CONFIG.sensorObserver = self
            return self.activityRecognitionSensor
        }else{
            return nil
        }
    }

    var activityRecognitionSensor:ActivityRecognitionSensor?

    public override init() {
        super.init()
        super.initializationCallEventHandler = self
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftAwareframeworkActivityrecognitionPlugin()
        super.setMethodChannel(with: registrar, instance: instance, channelName: "awareframework_activityrecognition/method")
        super.setEventChannels(with: registrar, instance: instance, channelNames: ["awareframework_activityrecognition/event"])
    }


    public func onActivityChanged(data: Array<ActivityRecognitionData>) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_data_changed" {
                for activity in data {
                    handler.eventSink(activity.toDictionary())
                }
            }
        }
    }
}
