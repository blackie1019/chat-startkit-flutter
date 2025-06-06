import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math' show Random;
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

import '../models/message.dart';
import 'encryption_service.dart';

class WebSocketService {
  final String url;
  WebSocketChannel? _channel;
  final _controller = StreamController<Message>.broadcast();

  Stream<Message> get messages => _controller.stream;

  WebSocketService(this.url);

  String _normalizeUrl(String raw) {
    try {
      var sanitized = raw.trim();
      
      // Remove any trailing slashes and fragments
      sanitized = sanitized.replaceAll(RegExp(r'#.*$'), '');
      sanitized = sanitized.replaceAll(RegExp(r'/+$'), '');
      
      // Ensure proper WebSocket protocol
      if (!sanitized.startsWith('ws://') && !sanitized.startsWith('wss://')) {
        if (sanitized.startsWith('https://')) {
          sanitized = 'wss://' + sanitized.substring(8);
        } else if (sanitized.startsWith('http://')) {
          sanitized = 'ws://' + sanitized.substring(7);
        } else {
          // Default to wss if no protocol is specified
          sanitized = 'wss://$sanitized';
        }
      }
      
      // Ensure the URL has a valid WebSocket path
      if (!sanitized.endsWith('/ws')) {
        sanitized = '$sanitized/ws';
      }
      
      developer.log('Normalized WebSocket URL: $sanitized');
      return sanitized;
    } catch (e) {
      developer.log('Error normalizing WebSocket URL: $e');
      rethrow;
    }
  }

  Future<void> connect() async {
    try {
      final normalizedUrl = _normalizeUrl(url);
      developer.log('Connecting to WebSocket: $normalizedUrl');
      
      final uri = Uri.parse(normalizedUrl);
      _channel = IOWebSocketChannel.connect(
        uri,
        protocols: ['chat-protocol'],
      );
      
      _channel!.stream.listen(
        (data) {
          try {
            developer.log('Received raw WebSocket data: $data');
            final decrypted = EncryptionService.decrypt(data as String);
            final jsonMap = json.decode(decrypted) as Map<String, dynamic>;
            _controller.add(Message.fromJson(jsonMap));
          } catch (e) {
            developer.log('Error processing WebSocket message: $e');
            _controller.addError(e);
          }
        },
        onError: (error) {
          developer.log('WebSocket error: $error');
          _controller.addError(error);
          reconnect();
        },
        onDone: () {
          developer.log('WebSocket connection closed');
          reconnect();
        },
        cancelOnError: true,
      );
      
      developer.log('WebSocket connected successfully');
    } catch (e) {
      developer.log('Failed to connect to WebSocket: $e');
      rethrow;
    }
  }

  void send(Message message) {
    try {
      final messageJson = json.encode(message.toJson());
      final encrypted = EncryptionService.encrypt(messageJson);
      if (_channel?.closeCode != null) {
        developer.log('WebSocket is closed, attempting to reconnect...');
        reconnect();
      } else {
        _channel?.sink.add(encrypted);
        developer.log('Message sent: $messageJson');
      }
    } catch (e) {
      developer.log('Error sending WebSocket message: $e');
      rethrow;
    }
  }

  Future<void> disconnect() async {
    await _channel?.sink.close();
    await _controller.close();
  }

  bool _isReconnecting = false;
  
  Future<void> reconnect() async {
    if (_isReconnecting) return;
    _isReconnecting = true;
    
    try {
      // Exponential backoff with jitter
      final retryCount = 0;
      final maxRetries = 5;
      final baseDelay = Duration(seconds: 1);
      
      while (retryCount < maxRetries) {
        final delay = Duration(
          milliseconds: (baseDelay.inMilliseconds * (1 << retryCount)) ~/ 2 +
              (baseDelay.inMilliseconds * 0.5 * (1 + Random().nextDouble())).toInt(),
        );
        
        developer.log('Attempting to reconnect in ${delay.inSeconds} seconds... (${retryCount + 1}/$maxRetries)');
        await Future.delayed(delay);
        
        try {
          await connect();
          break; // If connect() succeeds, exit the retry loop
        } catch (e) {
          developer.log('Reconnect attempt ${retryCount + 1} failed: $e');
          if (retryCount == maxRetries - 1) {
            _controller.addError(e);
          }
        }
      }
    } finally {
      _isReconnecting = false;
    }
  }
}
