// ignore: import_of_legacy_library_into_null_safe, library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';

typedef OnMessageCallback = void Function(String tag, dynamic msg);
typedef OnCloseCallback = void Function(int code, String reason);
typedef OnOpenCallback = void Function();

// ignore: constant_identifier_names
const EVENT = 'socket-event';

class SimpleWebSocket {
  late String url;
  late IO.Socket socket;
  late OnOpenCallback onOpen;
  late OnMessageCallback onMessage;
  late OnCloseCallback onClose;

  SimpleWebSocket(this.url);

  connect() async {
    try {
      socket = IO.io(url, <String, dynamic>{
        'transports': ['websocket']
      });
      // Dart client
      socket.on('connect', (_) {
        if (kDebugMode) {
          print('connected');
        }
        onOpen();
      });
      socket.on(EVENT, (data) {
        onMessage(EVENT, data);
      });
      // ignore: avoid_print
      socket.on('exception', (e) => print('Exception: $e'));
      // ignore: avoid_print
      socket.on('connect_error', (e) => print('Connect error: $e'));
      socket.on('disconnect', (e) {
        if (kDebugMode) {
          print('disconnect');
        }
        onClose(0, e);
      });
      // ignore: avoid_print
      socket.on('fromServer', (_) => print(_));
    } catch (e) {
      onClose(500, e.toString());
    }
  }

  send(event, data) {
    socket.emit(event, data);
    if (kDebugMode) {
      print('send: $event - $data');
    }
  }

  close() {
 socket.close();
  }
}
