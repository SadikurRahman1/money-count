import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/calculation_history_storage.dart';
import '../../data/note_storage.dart';
import '../history/history_page.dart';
import '../../models/calculation_record.dart';
import '../../utils/money_text.dart';
import 'widgets/note_editor_sheet.dart';
import 'widgets/note_row.dart';
import 'widgets/total_card.dart';

class NoteCounterPage extends StatefulWidget {
  const NoteCounterPage({super.key});

  @override
  State<NoteCounterPage> createState() => _NoteCounterPageState();
}

class _NoteCounterPageState extends State<NoteCounterPage> {
  final List<int> _notes = [1000, 500, 200, 100, 50, 20, 10, 5, 2, 1];
  final CalculationHistoryStorage _historyStorage = CalculationHistoryStorage();
  final NoteStorage _noteStorage = NoteStorage();
  late final Map<int, TextEditingController> _controllers;
  final List<TextEditingController> _removedControllers = [];

  @override
  void initState() {
    super.initState();
    _controllers = {for (final note in _notes) note: TextEditingController()};
    _loadSavedNotes();
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    for (final controller in _removedControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  int _countFor(int note) => int.tryParse(_controllers[note]!.text) ?? 0;

  int get _total =>
      _notes.fold(0, (total, note) => total + note * _countFor(note));

  void _changeCount(int note, int change) {
    final count = (_countFor(note) + change).clamp(0, 99999);
    _controllers[note]!.text = count == 0 ? '' : count.toString();
    setState(() {});
  }

  void _clearAll() {
    for (final controller in _controllers.values) {
      controller.clear();
    }
    setState(() {});
  }

  void _applyNotes(List<int> updatedNotes) {
    final oldNotes = Set<int>.from(_notes);
    final newNotes = Set<int>.from(updatedNotes);

    setState(() {
      for (final note in oldNotes.difference(newNotes)) {
        final controller = _controllers.remove(note);
        if (controller != null) _removedControllers.add(controller);
      }
      for (final note in newNotes.difference(oldNotes)) {
        _controllers[note] = TextEditingController();
      }
      _notes
        ..clear()
        ..addAll(updatedNotes)
        ..sort((first, second) => second.compareTo(first));
    });
    _saveNotes();
  }

  Future<void> _loadSavedNotes() async {
    final savedNotes = await _noteStorage.loadNotes();
    if (!mounted || savedNotes == null) return;
    _applyNotes(savedNotes);
  }

  Future<void> _saveNotes() => _noteStorage.saveNotes(List<int>.from(_notes));

  Map<int, int> get _activeNoteCounts => {
    for (final note in _notes)
      if (_countFor(note) > 0) note: _countFor(note),
  };

  // String get _calculationText {
  //   final noteLines = _activeNoteCounts.entries.map(
  //     (entry) =>
  //         '৳${entry.key} × ${entry.value} = ৳ ${formatMoney(entry.key * entry.value)}',
  //   );
  //   return [
  //     'নোট হিসাব',
  //     'মোট টাকা: ৳ ${formatMoney(_total)}',
  //     banglaTakaInWords(_total),
  //     englishTakaInWords(_total),
  //     '',
  //     'নোটের হিসাব:',
  //     ...noteLines,
  //   ].join('\n');
  // }

  Future<String?> _askForSaveNote() {
    var note = '';
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('হিসাব সংরক্ষণ করুন'),
        content: TextField(
          autofocus: true,
          maxLines: 2,
          onChanged: (value) => note = value,
          decoration: const InputDecoration(
            labelText: 'নোট (ঐচ্ছিক)',
            hintText: 'যেমন: ব্যাংকে জমা',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('বাতিল')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, note.trim()), child: const Text('সংরক্ষণ করুন')),
        ],
      ),
    );
  }

  Future<void> _saveCalculation() async {
    if (_total == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('সংরক্ষণ করার জন্য নোটের সংখ্যা দিন')),
      );
      return;
    }
    final note = await _askForSaveNote();
    if (!mounted || note == null) return;
    final now = DateTime.now();
    await _historyStorage.save(
      CalculationRecord(
        id: now.microsecondsSinceEpoch.toString(),
        createdAt: now,
      total: _total,
      noteCounts: _activeNoteCounts,
      note: note,
      ),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('তারিখ ও সময়সহ হিসাব সংরক্ষণ হয়েছে')),
    );
  }

  // Future<void> _shareCalculation() async {
  //   if (_total == 0) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('শেয়ার করার জন্য নোটের সংখ্যা দিন')),
  //     );
  //     return;
  //   }
  //   await Share.share(_calculationText);
  // }

  Future<void> _openHistory() => Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => HistoryPage(storage: _historyStorage)),
  );

  Future<void> _showNoteEditor() async {
    final updatedNotes = await showNoteEditorSheet(context, _notes);
    if (!mounted || updatedNotes == null) return;
    _applyNotes(updatedNotes);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: const Color(0xffF6F8F5),
      surfaceTintColor: Colors.transparent,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('নোট হিসাব', style: TextStyle(fontWeight: FontWeight.w800)),
          Text('ব্যাংকে জমার টাকার হিসাব', style: TextStyle(fontSize: 12)),
        ],
      ),
      actions: [
        IconButton(
          onPressed: _saveCalculation,
          icon: const Icon(Icons.save_outlined),
          tooltip: 'হিসাব সংরক্ষণ করুন',
        ),
        // IconButton(
        //   onPressed: _shareCalculation,
        //   icon: const Icon(Icons.share_outlined),
        //   tooltip: 'হিসাব শেয়ার করুন',
        // ),
        IconButton(
          onPressed: _openHistory,
          icon: const Icon(Icons.history),
          tooltip: 'হিসাবের ইতিহাস',
        ),
        IconButton(
          color: Colors.red,
          onPressed: _clearAll,
          icon: const Icon(Icons.restart_alt),
          tooltip: 'সব মুছুন',
        ),
      ],
    ),
    body: SafeArea(
      child: Column(
        children: [
          TotalCard(total: _total),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 12, 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'কতটি নোট আছে?',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                  ),
                ),
                IconButton(
                  onPressed: _showNoteEditor,
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'নোট সম্পাদনা করুন',
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: _notes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final note = _notes[index];
                return NoteRow(
                  note: note,
                  controller: _controllers[note]!,
                  onChanged: () => setState(() {}),
                  onDecrease: () => _changeCount(note, -1),
                  onIncrease: () => _changeCount(note, 1),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
