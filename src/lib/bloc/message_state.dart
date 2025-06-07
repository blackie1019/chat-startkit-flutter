part of 'message_bloc.dart';

class MessageState extends Equatable {
  final List<Message> messages;
  final String? error;
  final bool isConnecting;

  const MessageState({
    this.messages = const [],
    this.error,
    this.isConnecting = false,
  });

  MessageState copyWith({
    List<Message>? messages,
    String? error,
    bool? isConnecting,
  }) {
    return MessageState(
      messages: messages ?? this.messages,
      error: error,
      isConnecting: isConnecting ?? this.isConnecting,
    );
  }

  @override
  List<Object?> get props => [messages, error, isConnecting];
}
