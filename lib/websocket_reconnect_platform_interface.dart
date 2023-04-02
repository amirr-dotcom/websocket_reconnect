import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'websocket_reconnect_method_channel.dart';

abstract class WebsocketReconnectPlatform extends PlatformInterface {
  /// Constructs a WebsocketReconnectPlatform.
  WebsocketReconnectPlatform() : super(token: _token);

  static final Object _token = Object();

  static WebsocketReconnectPlatform _instance = MethodChannelWebsocketReconnect();

  /// The default instance of [WebsocketReconnectPlatform] to use.
  ///
  /// Defaults to [MethodChannelWebsocketReconnect].
  static WebsocketReconnectPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WebsocketReconnectPlatform] when
  /// they register themselves.
  static set instance(WebsocketReconnectPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
