import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'websocket_reconnect_platform_interface.dart';

/// An implementation of [WebsocketReconnectPlatform] that uses method channels.
class MethodChannelWebsocketReconnect extends WebsocketReconnectPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('websocket_reconnect');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
