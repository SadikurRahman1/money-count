import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<List<int>?> showNoteEditorSheet(BuildContext context, List<int> notes) =>
    showModalBottomSheet<List<int>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => NoteEditorSheet(notes: notes),
    );

class NoteEditorSheet extends StatefulWidget {
  const NoteEditorSheet({super.key, required this.notes});

  final List<int> notes;

  @override
  State<NoteEditorSheet> createState() => _NoteEditorSheetState();
}

class _NoteEditorSheetState extends State<NoteEditorSheet> {
  late final List<int> _draftNotes = List<int>.from(widget.notes);
  final _newNoteController = TextEditingController();

  @override
  void dispose() {
    _newNoteController.dispose();
    super.dispose();
  }

  void _addNote() {
    final note = int.tryParse(_newNoteController.text);
    if (note == null || note <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('সঠিক নোটের amount লিখুন')));
      return;
    }
    if (_draftNotes.contains(note)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('এই নোটটি তালিকায় আগে থেকেই আছে')),
      );
      return;
    }
    setState(() {
      _draftNotes.add(note);
      _draftNotes.sort((first, second) => second.compareTo(first));
      _newNoteController.clear();
    });
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.fromLTRB(
      20,
      16,
      20,
      MediaQuery.viewInsetsOf(context).bottom + 24,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'নোট সম্পাদনা',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        const Text('নোট মুছুন বা নতুন নোট যোগ করুন'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _draftNotes
              .map(
                (note) => InputChip(
                  label: Text('৳$note'),
                  onDeleted: () => setState(() => _draftNotes.remove(note)),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 20),
        const Text(
          'নতুন নোট যোগ করুন',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _newNoteController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  prefixText: '৳ ',
                  hintText: 'যেমন: 1000',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            FilledButton(onPressed: _addNote, child: const Text('যোগ করুন')),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () =>
                Navigator.pop(context, List<int>.from(_draftNotes)),
            icon: const Icon(Icons.save_outlined),
            label: const Text('পরিবর্তন সংরক্ষণ করুন'),
          ),
        ),
      ],
    ),
  );
}
