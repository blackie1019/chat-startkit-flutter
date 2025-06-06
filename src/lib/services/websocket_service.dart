import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/message.dart';
import 'encryption_service.dart';

class WebSocketService {
  final String url;
  WebSocketChannel? _channel;
  final _controller = StreamController<Message>.broadcast();

  Stream<Message> get messages => _controller.stream;

  WebSocketService(this.url);

  String _normalizeUrl(String raw) {
    var sanitized = raw.trim();
    if (sanitized.startsWith('https://')) {
      sanitized = sanitized.replaceFirst('https://', 'wss://');
    } else if (sanitized.startsWith('http://')) {
      sanitized = sanitized.replaceFirst('http://', 'ws://');
    }
    sanitized = sanitized.replaceAll(RegExp(r'#.*$'), '');
    return sanitized;
  }

  Future<void> connect() async {
    final uri = Uri.parse(_normalizeUrl(url));
    _channel = WebSocketChannel.connect(uri);
    _channel!.stream.listen((data) {
      final decrypted = EncryptionService.decrypt(data as String);
      final jsonMap = json.decode(decrypted) as Map<String, dynamic>;
      _controller.add(Message.fromJson(jsonMap));
    }, onError: (error) {
      _controller.addError(error);
      reconnect();
    }, onDone: () {
      reconnect();
    });
  }

  void send(Message message) {
    final encrypted = EncryptionService.encrypt(json.encode(message.toJson()));
    _channel?.sink.add(encrypted);
  }

  Future<void> disconnect() async {
    await _channel?.sink.close();
    await _controller.close();
  }

  Future<void> reconnect() async {
    await Future.delayed(const Duration(seconds: 2));
    await connect();
  }
}
