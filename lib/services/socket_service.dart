import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'notification_service.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;

  void connect(String serverUrl) {
    socket = IO.io(
      serverUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      print('✅ Socket connected to $serverUrl');
    });

    socket!.on('pos:notify', (data) {
      print('📩 Realtime data masuk: $data');
      NotificationService().show(
        'Transaksi Baru',
        'Total: Rp ${data['total']}',
      );
    });

    socket!.onDisconnect((_) => print('❌ Socket disconnected'));
  }

  void sendTransaction(Map<String, dynamic> data) {
    socket?.emit('pos:transaction', data);
  }
}
