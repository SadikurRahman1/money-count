import 'package:shared_preferences/shared_preferences.dart';

class NoteStorage {
  static const _notesKey = 'note_denominations';

  Future<List<int>?> loadNotes() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences
        .getStringList(_notesKey)
        ?.map(int.tryParse)
        .whereType<int>()
        .toList();
  }

  Future<void> saveNotes(List<int> notes) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      _notesKey,
      notes.map((note) => note.toString()).toList(),
    );
  }
}
