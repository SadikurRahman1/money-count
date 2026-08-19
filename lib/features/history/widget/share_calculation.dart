import 'package:money_count/models/calculation_record.dart';
import 'package:money_count/utils/money_text.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  static String _dateTime(DateTime value) {
    String twoDigits(int number) =>
        number.toString().padLeft(2, '0');

    return '${twoDigits(value.day)}/${twoDigits(value.month)}/${value.year} • '
        '${twoDigits(value.hour)}:${twoDigits(value.minute)}';
  }

  static Future<void> shareCalculation(
    CalculationRecord record,
  ) async {
    final notes = record.noteCounts.entries.toList()
      ..sort(
        (first, second) => second.key.compareTo(first.key),
      );

    final noteDetails = notes.map((entry) {
      final amount = entry.key * entry.value;

      return '৳${entry.key} × ${entry.value} = '
          '৳${formatMoney(amount)}';
    }).join('\n');

    final text = '''
Money Count
Date: ${_dateTime(record.createdAt)}

নোটের হিসাব:
$noteDetails

Total Amount: ৳ ${formatMoney(record.total)}

In Words: ${englishTakaInWords(record.total)}

নোট: ${record.note.isEmpty ? 'কোনো নোট নেই' : record.note}
''';

    await Share.share(
      text,
      subject: 'Money Count - Calculation',
    );
  }
}