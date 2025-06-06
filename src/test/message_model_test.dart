import 'package:flutter_test/flutter_test.dart';
import 'package:chat_startkit_flutter/models/message.dart';

void main() {
  group('Message model', () {
    test('serialization/deserialization', () {
      final message = Message(
        id: '1',
        content: 'hello',
        timestamp: DateTime.parse('2023-01-01T12:00:00.000Z'),
      );
      final json = message.toJson();
      expect(json['id'], '1');
      expect(json['content'], 'hello');
      expect(json['timestamp'], '2023-01-01T12:00:00.000Z');

      final fromJson = Message.fromJson(json);
      expect(fromJson.id, message.id);
      expect(fromJson.content, message.content);
      expect(fromJson.timestamp, message.timestamp);
    });

    test('encodeList/decodeList', () {
      final messages = [
        Message(id: '1', content: 'A', timestamp: DateTime.utc(2023, 1, 1)),
        Message(id: '2', content: 'B', timestamp: DateTime.utc(2023, 1, 2)),
      ];
      final encoded = Message.encodeList(messages);
      final decoded = Message.decodeList(encoded);
      expect(decoded.length, 2);
      expect(decoded[0].id, messages[0].id);
      expect(decoded[1].content, messages[1].content);
    });
  });
}
