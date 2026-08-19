import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'round_button.dart';

class NoteRow extends StatelessWidget {
  const NoteRow({
    super.key,
    required this.note,
    required this.controller,
    required this.onChanged,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int note;
  final TextEditingController controller;
  final VoidCallback onChanged;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    final subtotal = note * (int.tryParse(controller.text) ?? 0);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffE2E9E3)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xffE3F3E9),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Text(
              '৳$note',
              style: const TextStyle(
                color: Color(0xff146C43),
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '৳ $subtotal',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          RoundButton(icon: Icons.remove, onPressed: onDecrease),
          SizedBox(
            width: 52,
            child: TextField(
              controller: controller,
              onChanged: (_) => onChanged(),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                hintText: '0',
                border: InputBorder.none,
                isDense: true,
              ),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          RoundButton(icon: Icons.add, onPressed: onIncrease),
        ],
      ),
    );
  }
}
