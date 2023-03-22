import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

String convertToUserFriendly(String word) {
  return word.split('_').map((e) => toBeginningOfSentenceCase(e)).join(' ');
}
