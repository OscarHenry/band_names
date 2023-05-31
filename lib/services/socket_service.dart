// ignore_for_file: library_prefixes

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  online(Icon(Icons.wifi_outlined, color: Colors.blue)),
  offline(Icon(Icons.wifi_off_outlined, color: Colors.grey)),
  connecting(Icon(Icons.wifi_find_outlined, color: Colors.yellow));

  const ServerStatus(this.icon);
  final Widget icon;

  bool get isOnline => this == ServerStatus.online;
  bool get isOffline => this == ServerStatus.offline;
  bool get isConnecting => this == ServerStatus.connecting;
}

class SocketService with ChangeNotifier {
  SocketService() {
    _initConfig();
  }

  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  set serverStatus(ServerStatus status) {
    _serverStatus = status;
    notifyListeners();
  }

  Function get emit => _socket.emit;

  void _initConfig() {
    // Dart client
    _socket = IO.io('http://localhost:3000/', {
      'transports': ['websocket'],
      'auto-connect': true
    });

    _socket.onConnect((_) {
      debugPrint('connect');
      serverStatus = ServerStatus.online;
    });

    _socket.onDisconnect((_) {
      debugPrint('disconnect');
      serverStatus = ServerStatus.offline;
    });
  }
}
