import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:web_socket_channel/web_socket_channel.dart';

main() {
  // Dart client
  print("started");
  IO.Socket socket = IO.io(
      'https://theworkflow.nyc/chat',
      IO.OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
          .build());
  socket.connect();

  socket.onConnect((_) {
    print('connect');
    socket.emit('connect1');

    print('sent');
    socket.on('*', (data) => handleMessage);
    socket.onDisconnect((_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
  });

  // socket.onpacket((packet) {
  //   print(packet);
  // });
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://theworkflow.nyc/chat/'),
  );

  channel.stream.listen((event) {
    print(event);
  });
  channel.sink.add("test");
}

handleMessage(Map<String, dynamic> data) async {
  print(data);
}
