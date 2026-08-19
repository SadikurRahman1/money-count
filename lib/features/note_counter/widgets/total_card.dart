import 'package:flutter/material.dart';

import '../../../utils/money_text.dart';
import 'copy_amount_line.dart';

class TotalCard extends StatelessWidget {
  const TotalCard({super.key, required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    final bangla = banglaTakaInWords(total);
    final english = englishTakaInWords(total);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff146C43),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30146C43),
            blurRadius: 16,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'মোট টাকা',
            style: TextStyle(color: Color(0xffD9F7E5), fontSize: 16),
          ),
          Text(
            '৳ ${formatMoney(total)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w800,
            ),
          ),
          CopyableAmountLine(label: 'বাংলা', text: bangla),
          CopyableAmountLine(label: 'English', text: english),
        ],
      ),
    );
  }
}
