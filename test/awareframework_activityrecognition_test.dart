import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:awareframework_activityrecognition/awareframework_activityrecognition.dart';

void main() {
  const MethodChannel channel =
      MethodChannel('awareframework_activityrecognition');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  // test('getPlatformVersion', () async {
  //   expect(await AwareframeworkActivityrecognition.platformVersion, '42');
  // });
}
