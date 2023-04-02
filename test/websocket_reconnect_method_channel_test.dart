import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:websocket_reconnect/websocket_reconnect_method_channel.dart';

void main() {
  MethodChannelWebsocketReconnect platform = MethodChannelWebsocketReconnect();
  const MethodChannel channel = MethodChannel('websocket_reconnect');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
