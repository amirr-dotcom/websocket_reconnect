import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
export 'websocket_reconnect.dart';
import 'websocket_reconnect.dart';
import 'dart:io' show Platform;


class WebsocketReconnect {
  final String url;
  final Duration delay;

  WebsocketReconnect({required this.url, required this.delay});

  Future<String> getPlatformVersion() async {
    return await Platform.operatingSystemVersion;
  }

  Future<void> scheduleReconnect() async {
    while (true) {
      await Future.delayed(delay);
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity != ConnectivityResult.none) {
        try {
          final channel = IOWebSocketChannel.connect(url);
          await channel.sink.done;
          await channel.stream.drain();
          print('Reconnected successfully');
          return;
        } catch (e) {
          print('Failed to connect: $e');
        }
      }
    }
  }
}
