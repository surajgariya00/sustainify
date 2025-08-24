import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'models/emission_factor.dart';
import 'models/entry.dart';

class CarbonCalculator {
  EmissionFactors? _factors;

  Future<void> load() async {
    final raw = await rootBundle.loadString('assets/emission_factors.json');
    final Map<String, dynamic> data = jsonDecode(raw) as Map<String, dynamic>;
    _factors = EmissionFactors.fromJson(data);
  }

  double computeKgCO2e(EntryType type, String label, double amount) {
    final f = _factors!;
    double factor = 0;
    switch (type) {
      case EntryType.transport:
        factor = f.transport['${label}_kg_per_km'] ?? 0;
        break;
      case EntryType.energy:
        factor =
            f.energy['${label}_kg_per_kwh'] ??
            f.energy['${label}_kg_per_kg'] ??
            0;
        break;
      case EntryType.food:
        factor =
            f.food['${label}_kg_per_kg'] ?? f.food['${label}_kg_per_l'] ?? 0;
        break;
      case EntryType.waste:
        factor = f.waste['${label}_kg_per_kg'] ?? 0;
        break;
    }
    return factor * amount;
  }
}
