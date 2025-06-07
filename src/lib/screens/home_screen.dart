import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/message_bloc.dart';
import '../models/message.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<MessageBloc>().add(const LoadMessages());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<MessageBloc>().add(const ReconnectWebSocket());
    }
  }

  @override
  Widget build(BuildContext context) {
    final brand = const String.fromEnvironment('BRAND', defaultValue: 'Default');
    final tenant = const String.fromEnvironment('TENANT', defaultValue: 'Main');

    return Scaffold(
      appBar: AppBar(title: Text('Chat - $brand/$tenant')),
      body: Column(
        children: [
          BlocBuilder<MessageBloc, MessageState>(
            builder: (context, state) {
              return state.isConnecting
                  ? const LinearProgressIndicator()
                  : const SizedBox.shrink();
            },
          ),
          Expanded(
            child: BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                if (state.messages.isEmpty) {
                  return const Center(child: Text('No messages'));
                }
                return ListView.builder(
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    return ListTile(
                      title: Text(message.content),
                      subtitle: Text(message.timestamp.toIso8601String()),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Message'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final text = _controller.text;
                    if (text.isNotEmpty) {
                      final message = Message(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        content: text,
                        timestamp: DateTime.now(),
                      );
                      context.read<MessageBloc>().add(SendMessage(message));
                      _controller.clear();
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
