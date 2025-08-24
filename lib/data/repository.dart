import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'models/entry.dart';
import '../storage/hive_boxes.dart';

class Repository {
  final _uuid = const Uuid();
  Box<Map> get _box => Hive.box<Map>(Boxes.entries);

  List<Entry> getAll() =>
      _box.values
          .map((m) => Entry.fromMap(Map<String, dynamic>.from(m)))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

  Future<Entry> add({
    required EntryType type,
    required DateTime timestamp,
    required double amount,
    required String label,
    required double kg,
  }) async {
    final e = Entry(
      id: _uuid.v4(),
      type: type,
      timestamp: timestamp,
      amount: amount,
      label: label,
      kgCO2e: kg,
    );
    await upsert(e);
    return e;
  }

  Future<void> upsert(Entry e) async => _box.put(e.id, e.toMap());
  Future<void> delete(String id) async => _box.delete(id);

  double totalBetween(DateTime start, DateTime end) => getAll()
      .where((e) => !e.timestamp.isBefore(start) && e.timestamp.isBefore(end))
      .fold(0.0, (s, e) => s + e.kgCO2e);

  Map<EntryType, double> totalsByType(DateTime start, DateTime end) {
    final map = {for (var t in EntryType.values) t: 0.0};
    for (final e in getAll()) {
      if (!e.timestamp.isBefore(start) && e.timestamp.isBefore(end)) {
        map[e.type] = (map[e.type] ?? 0) + e.kgCO2e;
      }
    }
    return map;
  }

  List<double> lastNDaysTotals(int n) {
    final now = DateTime.now();
    return List.generate(n, (i) {
      final dayStart = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: n - 1 - i));
      final dayEnd = dayStart.add(const Duration(days: 1));
      return totalBetween(dayStart, dayEnd);
    });
  }
}
