#import "AwareframeworkActivityrecognitionPlugin.h"
#if __has_include(<awareframework_activityrecognition/awareframework_activityrecognition-Swift.h>)
#import <awareframework_activityrecognition/awareframework_activityrecognition-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "awareframework_activityrecognition-Swift.h"
#endif

@implementation AwareframeworkActivityrecognitionPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAwareframeworkActivityrecognitionPlugin registerWithRegistrar:registrar];
}
@end
