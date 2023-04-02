import 'package:flutter_test/flutter_test.dart';
import 'package:websocket_reconnect/websocket_reconnect.dart';
import 'package:websocket_reconnect/websocket_reconnect_platform_interface.dart';
import 'package:websocket_reconnect/websocket_reconnect_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockWebsocketReconnectPlatform
    with MockPlatformInterfaceMixin
    implements WebsocketReconnectPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final WebsocketReconnectPlatform initialPlatform = WebsocketReconnectPlatform.instance;

  test('$MethodChannelWebsocketReconnect is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWebsocketReconnect>());
  });

  test('getPlatformVersion', () async {
    WebsocketReconnect websocketReconnectPlugin = WebsocketReconnect();
    MockWebsocketReconnectPlatform fakePlatform = MockWebsocketReconnectPlatform();
    WebsocketReconnectPlatform.instance = fakePlatform;

    expect(await websocketReconnectPlugin.getPlatformVersion(), '42');
  });
}
