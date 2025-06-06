part of 'message_bloc.dart';

class MessageState extends Equatable {
  final List<Message> messages;
  final String? error;

  const MessageState({this.messages = const [], this.error});

  MessageState copyWith({List<Message>? messages, String? error}) {
    return MessageState(
      messages: messages ?? this.messages,
      error: error,
    );
  }

  @override
  List<Object?> get props => [messages, error];
}
