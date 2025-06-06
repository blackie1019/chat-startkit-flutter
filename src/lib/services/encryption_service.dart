import 'dart:convert';
import 'package:crypto/crypto.dart';

class EncryptionService {
  // This is only a demo. In production, store keys securely.
  static const _key = 'temporary-key';

  static String encrypt(String input) {
    final bytes = utf8.encode('$_key$input');
    return base64Encode(bytes);
  }

  static String decrypt(String input) {
    final decoded = utf8.decode(base64Decode(input));
    return decoded.replaceFirst('$_key', '');
  }
}
