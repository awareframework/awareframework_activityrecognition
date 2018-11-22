#import "AwareframeworkActivityrecognitionPlugin.h"
#import <awareframework_activityrecognition/awareframework_activityrecognition-Swift.h>

@implementation AwareframeworkActivityrecognitionPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAwareframeworkActivityrecognitionPlugin registerWithRegistrar:registrar];
}
@end
