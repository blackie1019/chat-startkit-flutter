import 'dart:convert';

class Message {
  final String id;
  final String content;
  final DateTime timestamp;

  Message({required this.id, required this.content, required this.timestamp});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
      };

  static String encodeList(List<Message> messages) =>
      json.encode(messages.map((m) => m.toJson()).toList());

  static List<Message> decodeList(String source) =>
      (json.decode(source) as List)
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList();
}
