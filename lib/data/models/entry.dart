enum EntryType { transport, energy, food, waste }

class Entry {
  final String id;
  final EntryType type;
  final DateTime timestamp;
  final double amount; // meaning depends on type
  final String label; // e.g. car_petrol, electricity_grid, beef
  final double kgCO2e; // cached

  Entry({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.amount,
    required this.label,
    required this.kgCO2e,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type.name,
    'timestamp': timestamp.toIso8601String(),
    'amount': amount,
    'label': label,
    'kgCO2e': kgCO2e,
  };

  factory Entry.fromMap(Map map) => Entry(
    id: map['id'] as String,
    type: EntryType.values.firstWhere((e) => e.name == map['type']),
    timestamp: DateTime.parse(map['timestamp'] as String),
    amount: (map['amount'] as num).toDouble(),
    label: map['label'] as String,
    kgCO2e: (map['kgCO2e'] as num).toDouble(),
  );
}
