import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:websocket_reconnect/websocket_reconnect.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebSocket Demo',
      home: CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;
  WebSocketChannel? _channel;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
  }

  @override
  void dispose() {
    _disconnectFromWebSocket();
    super.dispose();
  }

  void _connectToWebSocket() async {
    final url = 'ws://echo.websocket.events';
    final delay = Duration(seconds: 3);

    final channel = IOWebSocketChannel.connect(url);

    channel.stream.listen((message) {
      setState(() {
        _count = int.parse(message);
      });
    }, onError: (error) {
      print('WebSocket error: $error');
      _isConnected = false;
      _showConnectionLostDialog();
      WebSocketChannelExt(url: url, delay: delay).scheduleReconnect();
    }, onDone: () {
      print('WebSocket done');
      _isConnected = false;
      _showConnectionLostDialog();
      WebSocketChannelExt(url: url, delay: delay).scheduleReconnect();
    }, cancelOnError: true);

    _channel = channel;
    _isConnected = true;

    Connectivity().onConnectivityChanged.listen((result) {
      if ((result == ConnectivityResult.mobile ||
              result == ConnectivityResult.wifi) &&
          !_isConnected) {
        _connectToWebSocket();
      }
    });
  }

  void _disconnectFromWebSocket() {
    _channel?.sink.close(status.goingAway);
  }

  void _showConnectionLostDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Connection Lost'),
          content: Text('Attempting to reconnect...'),
        );
      },
    );
  }

  void _incrementCounter() {
    _channel?.sink.add((_count + 1).toString());
  }

  void _decrementCounter() {
    _channel?.sink.add((_count - 1).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter WebSocket Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 16),
            Text(
              '$_count',
              style: Theme.of(context).textTheme.headline1,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
