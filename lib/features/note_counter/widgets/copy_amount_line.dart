import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyableAmountLine extends StatelessWidget {
  const CopyableAmountLine({
    super.key,
    required this.label,
    required this.text,
  });

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(text, style: const TextStyle(color: Color(0xffD9F7E5))),
      ),
      IconButton(
        onPressed: () async {
          await Clipboard.setData(ClipboardData(text: text));
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('"$text" লেখা কপি হয়েছে'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        icon: const Icon(Icons.copy_outlined, size: 18),
        tooltip: '$label কপি করুন',
        color: Colors.white,
        visualDensity: VisualDensity.compact,
      ),
    ],
  );
}
