import 'dart:convert';

import 'package:crypto/crypto.dart';
class Cryptography {
 static String encryptData(String data) {
    final key = utf8.encode('hari12345@#');
    final bytes = utf8.encode(data);
    final hmacSha256 = Hmac(sha256, key); // Use HMAC-SHA256 for encryption
    final digest = hmacSha256.convert(bytes);
    return base64Encode(digest.bytes);
  }
}
