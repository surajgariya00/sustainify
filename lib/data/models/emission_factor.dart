class EmissionFactors {
  final Map<String, double> transport;
  final Map<String, double> energy;
  final Map<String, double> food;
  final Map<String, double> waste;

  EmissionFactors({
    required this.transport,
    required this.energy,
    required this.food,
    required this.waste,
  });
  factory EmissionFactors.fromJson(Map<String, dynamic> json) {
    Map<String, double> _to(Map<String, dynamic> m) =>
        m.map((k, v) => MapEntry(k, (v as num).toDouble()));

    return EmissionFactors(
      transport: _to(json['transport'] as Map<String, dynamic>),
      energy: _to(json['energy'] as Map<String, dynamic>),
      food: _to(json['food'] as Map<String, dynamic>),
      waste: _to(json['waste'] as Map<String, dynamic>),
    );
  }
}
