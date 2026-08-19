import 'package:flutter/material.dart';
import 'package:money_count/features/history/widget/delete_record_button.dart';
import 'package:money_count/features/history/widget/share_calculation.dart';
import '../../data/calculation_history_storage.dart';
import '../../models/calculation_record.dart';
import '../../utils/money_text.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key, required this.storage});

  final CalculationHistoryStorage storage;

  String _dateTime(DateTime value) {
    String twoDigits(int number) => number.toString().padLeft(2, '0');
    return '${twoDigits(value.day)}/${twoDigits(value.month)}/${value.year} • ${twoDigits(value.hour)}:${twoDigits(value.minute)}';
  }

  void _showDetails(BuildContext context, CalculationRecord record) {
    final notes = record.noteCounts.entries.toList()
      ..sort((first, second) => second.key.compareTo(first.key));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '৳ ${formatMoney(record.total)}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  _dateTime(record.createdAt),
                  style: TextStyle(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 20),

                const Text(
                  'নোটের হিসাব',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),

                const SizedBox(height: 12),

                ...notes.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('৳${entry.key} × ${entry.value}'),
                        Text(
                          '৳ ${formatMoney(entry.key * entry.value)}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(height: 30),

                const Text(
                  'Amount in Words',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                // Text(banglaTakaInWords(record.total)),
                Text(englishTakaInWords(record.total)),

                const SizedBox(height: 20),

                const Text(
                  'নোট',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Text(record.note.isEmpty ? 'কোনো নোট নেই' : record.note),

                const SizedBox(height: 20),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ShareService.shareCalculation(record);
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('হিসাব শেয়ার করুন'),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('বন্ধ করুন'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('হিসাবের ইতিহাস')),
    body: FutureBuilder<List<CalculationRecord>>(
      future: storage.load(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final records = snapshot.data!;
        if (records.isEmpty)
          return const Center(child: Text('এখনও কোনো হিসাব সংরক্ষণ করা হয়নি'));

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: records.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final record = records[index];
            return Card(
              child: ListTile(
                onTap: () => _showDetails(context, record),
                leading: const CircleAvatar(
                  child: Icon(Icons.receipt_long_outlined),
                ),
                title: Text(
                  '৳ ${formatMoney(record.total)}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(
                  '${_dateTime(record.createdAt)}\n${record.noteCounts.length} ধরনের নোট',
                ),
                isThreeLine: true,
                trailing: DeleteRecordButton(record: record, storage: storage),
              ),
            );
          },
        );
      },
    ),
  );
}
