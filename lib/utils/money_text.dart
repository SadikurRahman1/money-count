const _banglaUnderHundred = [
  'শূন্য',
  'এক',
  'দুই',
  'তিন',
  'চার',
  'পাঁচ',
  'ছয়',
  'সাত',
  'আট',
  'নয়',
  'দশ',
  'এগারো',
  'বারো',
  'তেরো',
  'চৌদ্দ',
  'পনেরো',
  'ষোলো',
  'সতেরো',
  'আঠারো',
  'উনিশ',
  'বিশ',
  'একুশ',
  'বাইশ',
  'তেইশ',
  'চব্বিশ',
  'পঁচিশ',
  'ছাব্বিশ',
  'সাতাশ',
  'আঠাশ',
  'ঊনত্রিশ',
  'ত্রিশ',
  'একত্রিশ',
  'বত্রিশ',
  'তেত্রিশ',
  'চৌত্রিশ',
  'পঁয়ত্রিশ',
  'ছত্রিশ',
  'সাঁইত্রিশ',
  'আটত্রিশ',
  'ঊনচল্লিশ',
  'চল্লিশ',
  'একচল্লিশ',
  'বিয়াল্লিশ',
  'তেতাল্লিশ',
  'চুয়াল্লিশ',
  'পঁয়তাল্লিশ',
  'ছেচল্লিশ',
  'সাতচল্লিশ',
  'আটচল্লিশ',
  'ঊনপঞ্চাশ',
  'পঞ্চাশ',
  'একান্ন',
  'বাহান্ন',
  'তিপ্পান্ন',
  'চুয়ান্ন',
  'পঞ্চান্ন',
  'ছাপ্পান্ন',
  'সাতান্ন',
  'আটান্ন',
  'ঊনষাট',
  'ষাট',
  'একষট্টি',
  'বাষট্টি',
  'তেষট্টি',
  'চৌষট্টি',
  'পঁয়ষট্টি',
  'ছেষট্টি',
  'সাতষট্টি',
  'আটষট্টি',
  'ঊনসত্তর',
  'সত্তর',
  'একাত্তর',
  'বাহাত্তর',
  'তিয়াত্তর',
  'চুয়াত্তর',
  'পঁচাত্তর',
  'ছিয়াত্তর',
  'সাতাত্তর',
  'আটাত্তর',
  'ঊনআশি',
  'আশি',
  'একাশি',
  'বিরাশি',
  'তিরাশি',
  'চুরাশি',
  'পঁচাশি',
  'ছিয়াশি',
  'সাতাশি',
  'আটাশি',
  'ঊননব্বই',
  'নব্বই',
  'একানব্বই',
  'বিরানব্বই',
  'তিরানব্বই',
  'চুরানব্বই',
  'পঁচানব্বই',
  'ছিয়ানব্বই',
  'সাতানব্বই',
  'আটানব্বই',
  'নিরানব্বই',
];

const _englishUnderTwenty = [
  'zero',
  'one',
  'two',
  'three',
  'four',
  'five',
  'six',
  'seven',
  'eight',
  'nine',
  'ten',
  'eleven',
  'twelve',
  'thirteen',
  'fourteen',
  'fifteen',
  'sixteen',
  'seventeen',
  'eighteen',
  'nineteen',
];
const _englishTens = [
  '',
  '',
  'twenty',
  'thirty',
  'forty',
  'fifty',
  'sixty',
  'seventy',
  'eighty',
  'ninety',
];

String formatMoney(int amount) {
  final digits = amount.toString();
  if (digits.length <= 3) return digits;

  final lastThree = digits.substring(digits.length - 3);
  var remaining = digits.substring(0, digits.length - 3);
  final groups = <String>[];
  while (remaining.length > 2) {
    groups.insert(0, remaining.substring(remaining.length - 2));
    remaining = remaining.substring(0, remaining.length - 2);
  }
  groups.insert(0, remaining);
  return '${groups.join(',')},$lastThree';
}

String banglaTakaInWords(int value) => '${_banglaWords(value)} টাকা মাত্র';

String englishTakaInWords(int value) {
  final words = '${_englishWords(value)} taka only';

  return words
      .split(' ')
      .map(
        (word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
      )
      .join(' ');
}

String _banglaWords(int value) {
  if (value < 100) return _banglaUnderHundred[value];
  if (value < 1000) {
    final rest = value % 100;
    return '${_banglaUnderHundred[value ~/ 100]}শত${rest == 0 ? '' : ' ${_banglaWords(rest)}'}';
  }
  return _withLargeUnit(value, [
    (10000000, 'কোটি'),
    (100000, 'লাখ'),
    (1000, 'হাজার'),
  ], _banglaWords);
}

String _englishWords(int value) {
  if (value < 20) return _englishUnderTwenty[value];
  if (value < 100) {
    final rest = value % 10;
    return '${_englishTens[value ~/ 10]}${rest == 0 ? '' : ' ${_englishWords(rest)}'}';
  }
  if (value < 1000) {
    final rest = value % 100;
    return '${_englishUnderTwenty[value ~/ 100]} hundred${rest == 0 ? '' : ' ${_englishWords(rest)}'}';
  }
  return _withLargeUnit(value, [
    (10000000, 'crore'),
    (100000, 'lakh'),
    (1000, 'thousand'),
  ], _englishWords);
}

String _withLargeUnit(
  int value,
  List<(int, String)> units,
  String Function(int) convert,
) {
  for (final unit in units) {
    if (value >= unit.$1) {
      final rest = value % unit.$1;
      return '${convert(value ~/ unit.$1)} ${unit.$2}${rest == 0 ? '' : ' ${convert(rest)}'}';
    }
  }
  return '';
}
