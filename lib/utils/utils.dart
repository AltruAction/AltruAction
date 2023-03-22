import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import '../string_extension.dart';

String convertToUserFriendly(String word) {
  return word.split('_').map((e) => e.toTitleCase()).join(' ');
}
