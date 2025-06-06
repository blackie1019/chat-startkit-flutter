import 'package:flutter_test/flutter_test.dart';
import 'package:chat_startkit_flutter/services/encryption_service.dart';

void main() {
  test('encrypt/decrypt roundtrip', () {
    const original = 'secret message';
    final encrypted = EncryptionService.encrypt(original);
    expect(encrypted, isNot(equals(original)));

    final decrypted = EncryptionService.decrypt(encrypted);
    expect(decrypted, equals(original));
  });
}
