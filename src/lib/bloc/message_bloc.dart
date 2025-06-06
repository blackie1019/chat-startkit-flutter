import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/message.dart';
import '../services/local_storage_service.dart';
import '../services/websocket_service.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final WebSocketService socketService;
  final LocalStorageService storageService;
  StreamSubscription<Message>? _socketSub;

  MessageBloc({required this.socketService, required this.storageService})
      : super(const MessageState()) {
    on<LoadMessages>(_onLoad);
    on<SendMessage>(_onSend);
    on<_ReceivedMessage>(_onReceived);
    on<_ErrorReceived>(_onError);
  }

  Future<void> _onLoad(LoadMessages event, Emitter<MessageState> emit) async {
    final cached = await storageService.getCachedMessages();
    emit(state.copyWith(messages: cached));
    await socketService.connect();
    _socketSub = socketService.messages.listen(
      (message) => add(_ReceivedMessage(message)),
      onError: (error) => add(_ErrorReceived(error.toString())),
    );
  }

  Future<void> _onSend(SendMessage event, Emitter<MessageState> emit) async {
    socketService.send(event.message);
    final updated = List<Message>.from(state.messages)..add(event.message);
    await storageService.cacheMessages(updated);
    emit(state.copyWith(messages: updated));
  }

  Future<void> _onReceived(
      _ReceivedMessage event, Emitter<MessageState> emit) async {
    final updated = List<Message>.from(state.messages)..add(event.message);
    await storageService.cacheMessages(updated);
    emit(state.copyWith(messages: updated));
  }

  Future<void> _onError(_ErrorReceived event, Emitter<MessageState> emit) async {
    emit(state.copyWith(error: event.error));
  }

  @override
  Future<void> close() {
    _socketSub?.cancel();
    socketService.disconnect();
    return super.close();
  }
}
