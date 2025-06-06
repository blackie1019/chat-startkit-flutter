import 'package:shared_preferences/shared_preferences.dart';

import '../models/message.dart';

class LocalStorageService {
  static const _messagesKey = 'cached_messages';

  Future<void> cacheMessages(List<Message> messages) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_messagesKey, Message.encodeList(messages));
  }

  Future<List<Message>> getCachedMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_messagesKey);
    if (data == null) return [];
    return Message.decodeList(data);
  }
}
