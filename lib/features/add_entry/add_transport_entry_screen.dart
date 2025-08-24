import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/carbon_calculator.dart';
import '../../data/repository.dart';
import '../../data/models/entry.dart';

class AddTransportEntryScreen extends StatefulWidget {
  const AddTransportEntryScreen({super.key});

  @override
  State<AddTransportEntryScreen> createState() =>
      _AddTransportEntryScreenState();
}

class _AddTransportEntryScreenState extends State<AddTransportEntryScreen> {
  final _form = GlobalKey<FormState>();
  final _kmCtrl = TextEditingController();
  String _mode = 'car_petrol';
  final _calc = CarbonCalculator();
  final _repo = Repository();

  @override
  void initState() {
    super.initState();
    _calc.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add transport')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _mode,
                items: const [
                  DropdownMenuItem(
                    value: 'car_petrol',
                    child: Text('Car (petrol)'),
                  ),
                  DropdownMenuItem(
                    value: 'car_diesel',
                    child: Text('Car (diesel)'),
                  ),
                  DropdownMenuItem(value: 'bus', child: Text('Bus')),
                  DropdownMenuItem(value: 'metro', child: Text('Metro')),
                  DropdownMenuItem(value: 'rail', child: Text('Rail')),
                  DropdownMenuItem(value: 'flight', child: Text('Flight')),
                  DropdownMenuItem(
                    value: 'bike_walk',
                    child: Text('Bike/Walk (0)'),
                  ),
                ],
                onChanged: (v) => setState(() => _mode = v!),
                decoration: const InputDecoration(
                  labelText: 'Mode of transport',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _kmCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Distance (km)'),
                validator: (v) {
                  final x = double.tryParse(v ?? '');
                  if (x == null || x <= 0) return 'Enter a positive number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save'),
                onPressed: () async {
                  if (!_form.currentState!.validate()) return;
                  final km = double.parse(_kmCtrl.text);
                  final kg = _calc.computeKgCO2e(
                    EntryType.transport,
                    _mode,
                    km,
                  );
                  await _repo.add(
                    type: EntryType.transport,
                    timestamp: DateTime.now(),
                    amount: km,
                    label: _mode,
                    kg: kg,
                  );
                  if (mounted) context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
