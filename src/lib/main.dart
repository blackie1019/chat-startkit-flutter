import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/message_bloc.dart';
import 'screens/home_screen.dart';
import 'services/local_storage_service.dart';
import 'services/websocket_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = WebSocketService('wss://example.com/ws');
    final storageService = LocalStorageService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MessageBloc(
            socketService: socketService,
            storageService: storageService,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Chat',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
