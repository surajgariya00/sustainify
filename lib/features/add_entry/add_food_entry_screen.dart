import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/carbon_calculator.dart';
import '../../data/repository.dart';
import '../../data/models/entry.dart';

class AddFoodEntryScreen extends StatefulWidget {
  const AddFoodEntryScreen({super.key});

  @override
  State<AddFoodEntryScreen> createState() => _AddFoodEntryScreenState();
}

class _AddFoodEntryScreenState extends State<AddFoodEntryScreen> {
  final _form = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  String _label = 'beef';
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
      appBar: AppBar(title: const Text('Add food')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _label,
                items: const [
                  DropdownMenuItem(value: 'beef', child: Text('Beef (kg)')),
                  DropdownMenuItem(
                    value: 'chicken',
                    child: Text('Chicken (kg)'),
                  ),
                  DropdownMenuItem(
                    value: 'vegetables',
                    child: Text('Vegetables (kg)'),
                  ),
                  DropdownMenuItem(value: 'rice', child: Text('Rice (kg)')),
                  DropdownMenuItem(value: 'milk', child: Text('Milk (L)')),
                  DropdownMenuItem(value: 'tofu', child: Text('Tofu (kg)')),
                ],
                onChanged: (v) => setState(() => _label = v!),
                decoration: const InputDecoration(labelText: 'Food item'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount (kg/L)'),
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
                  final amount = double.parse(_amountCtrl.text);
                  final kg = _calc.computeKgCO2e(
                    EntryType.food,
                    _label,
                    amount,
                  );
                  await _repo.add(
                    type: EntryType.food,
                    timestamp: DateTime.now(),
                    amount: amount,
                    label: _label,
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
