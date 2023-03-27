import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import '../string_extension.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:collection/collection.dart';

String convertToUserFriendly(String word) {
  return word.split('_').map((e) => e.toTitleCase()).join(' ');
}

// TODO shift to more secure location for production
String secretKey = "MarcusTaufiqCedricKevin";
String splitToken = "||";
String startToken = "reCloset";

String generateAndSignMessage(String id) {
  String message = "$startToken-$id-${DateTime.now().millisecondsSinceEpoch}";
  final bytes = utf8.encode(message);
  final hmac = Hmac(sha256, utf8.encode(secretKey));
  final signature = hmac.convert(bytes);
  final signedMessage =
      '$message${splitToken}${base64.encode(signature.bytes)}';
  return signedMessage;
}

bool verifySignature(String signedMessage) {
  int messageLength = signedMessage.indexOf(splitToken);
  final message = signedMessage.substring(0, messageLength);
  final signatureString =
      signedMessage.substring(messageLength + splitToken.length);
  final signature = base64.decode(signatureString);
  final bytes = utf8.encode(message);
  final hmac = Hmac(sha256, utf8.encode(secretKey));
  final calculatedSignature = hmac.convert(bytes);
  return ListEquality().equals(signature, calculatedSignature.bytes);
}

bool isValidStartToken(String toCheck) {
  for (int i = 0; i < startToken.length; i++) {
    if (startToken[i] != toCheck[i]) {
      return false;
    }
  }
  return true;
}
