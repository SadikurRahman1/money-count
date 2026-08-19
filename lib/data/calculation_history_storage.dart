import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/calculation_record.dart';

class CalculationHistoryStorage {
  static const _historyKey = 'calculation_history';
  static const _maximumRecords = 100;

  Future<List<CalculationRecord>> load() async {
    final preferences = await SharedPreferences.getInstance();
    final rawHistory = preferences.getString(_historyKey);
    if (rawHistory == null) return [];

    try {
      final decoded = jsonDecode(rawHistory) as List<dynamic>;
      return decoded
          .map(
            (item) => CalculationRecord.fromJson(item as Map<String, dynamic>),
          )
          .toList()
        ..sort((first, second) => second.createdAt.compareTo(first.createdAt));
    } catch (_) {
      return [];
    }
  }

  Future<void> save(CalculationRecord record) async {
    final history = await load();
    history.insert(0, record);
    if (history.length > _maximumRecords)
      history.removeRange(_maximumRecords, history.length);

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _historyKey,
      jsonEncode(history.map((record) => record.toJson()).toList()),
    );
  }

  Future<void> delete(String recordId) async {
    final history = await load();
    history.removeWhere((record) => record.id == recordId);

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _historyKey,
      jsonEncode(history.map((record) => record.toJson()).toList()),
    );
  }
}
