part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object?> get props => [];
}

class LoadMessages extends MessageEvent {
  const LoadMessages();
}

class SendMessage extends MessageEvent {
  final Message message;
  const SendMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class _ReceivedMessage extends MessageEvent {
  final Message message;
  const _ReceivedMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class _ErrorReceived extends MessageEvent {
  final String error;
  const _ErrorReceived(this.error);

  @override
  List<Object?> get props => [error];
}
