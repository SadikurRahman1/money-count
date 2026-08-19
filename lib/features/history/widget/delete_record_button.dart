import 'package:flutter/material.dart';
import 'package:money_count/data/calculation_history_storage.dart';
import 'package:money_count/models/calculation_record.dart';
import 'package:money_count/utils/money_text.dart';

class DeleteRecordButton extends StatelessWidget {
  const DeleteRecordButton({
    super.key,
    required this.record,
    required this.storage,
  });

  final CalculationRecord record;
  final CalculationHistoryStorage storage;

  Future<void> _deleteRecord(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('হিসাব মুছে ফেলবেন?'),
          content: Text(
            '৳ ${formatMoney(record.total)}-এর এই হিসাবটি '
            'স্থায়ীভাবে মুছে যাবে।',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('বাতিল'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('মুছে ফেলুন'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    await storage.delete(record.id);

    if (context.mounted) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('হিসাবটি মুছে ফেলা হয়েছে'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _deleteRecord(context),
      icon: const Icon(Icons.delete_outline),
      tooltip: 'হিসাব মুছে ফেলুন',
      color: Colors.red,
    );
  }
}