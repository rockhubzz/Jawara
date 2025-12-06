import 'dart:io';
import 'dart:async';

class NetworkDiscovery {
  static Future<String?> discoverServer() async {
    final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    socket.broadcastEnabled = true;

    // Send broadcast packet
    socket.send("DISCOVER".codeUnits, InternetAddress("255.255.255.255"), 8888);

    final completer = Completer<String?>();

    // Listen to responses
    socket.listen((event) {
      if (event == RawSocketEvent.read) {
        final dg = socket.receive();
        if (dg != null) {
          final msg = String.fromCharCodes(dg.data);

          // Expected reply: "SERVER:192.168.x.x"
          if (msg.startsWith("SERVER:")) {
            final ip = msg.replaceFirst("SERVER:", "");
            if (!completer.isCompleted) {
              completer.complete(ip);
            }
            socket.close();
          }
        }
      }
    });

    // Timeout after 1 second so app never hangs
    return completer.future.timeout(
      const Duration(seconds: 1),
      onTimeout: () {
        socket.close();
        return null; // server not found
      },
    );
  }
}
