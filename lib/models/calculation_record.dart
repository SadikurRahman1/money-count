class CalculationRecord {
  const CalculationRecord({
    required this.id,
    required this.createdAt,
    required this.total,
    required this.noteCounts,
    required this.note,
  });

  final String id;
  final DateTime createdAt;
  final int total;
  final Map<int, int> noteCounts;
  final String note;

  Map<String, Object> toJson() => {
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'total': total,
        'noteCounts': noteCounts.map(
          (note, count) => MapEntry(note.toString(), count),
        ),
        'note': note,
  };

  factory CalculationRecord.fromJson(Map<String, dynamic> json) =>
      CalculationRecord(
        id: json['id'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        total: json['total'] as int,
        noteCounts: (json['noteCounts'] as Map<String, dynamic>).map(
          (note, count) => MapEntry(int.parse(note), count as int),
        ),
        note: json['note'] as String? ?? '',
      );
}
