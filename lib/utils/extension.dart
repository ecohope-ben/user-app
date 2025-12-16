import 'package:characters/characters.dart';

extension EmojiExtension on String {
  /// is contain Emoji
  bool get hasEmoji => RegExp(
    r'[\u{1F300}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{1F100}-\u{1F1FF}'
    r'\u{1F600}-\u{1F64F}\u{1F680}-\u{1F6FF}\u{1F900}-\u{1F9FF}\u{200D}\u{FE0F}\u{20E3}]',
    unicode: true,
  ).hasMatch(this);

  static final _emojiRegex = RegExp(
    r'[\u{1F300}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{1F100}-\u{1F1FF}'
    r'\u{1F600}-\u{1F64F}\u{1F680}-\u{1F6FF}\u{1F900}-\u{1F9FF}\u{200D}\u{FE0F}\u{20E3}\u{1FA00}-\u{1FAFF}]',
    unicode: true,
  );

  String? get firstEmoji {
    for (final char in characters) {
      if (_isEmojiChar(char)) {
        return char;
      }
    }
    return null;
  }

  static bool _isEmojiChar(String char) {

    if (!_emojiRegex.hasMatch(char)) return false;

    if (char == '#' || char == '*' || char == '0' || char == '1' || char == '2') {
      return '️' == char.characters.last;
    }

    return true;
  }

  /// check is only Emoji
  bool get isOnlyEmoji {
    return runes.every((code) =>
    code >= 0x1F000 ||
        (code >= 0x2600 && code <= 0x2BFF) ||
        code == 0x200D ||
        code == 0xFE0F ||
        code == 0x20E3
    );
  }
}