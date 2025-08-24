import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/repository.dart';
import '../../data/models/entry.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/stat_chip.dart';
import '../../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final repo = Repository();

  @override
  Widget build(BuildContext context) {
    final entries = repo.getAll();
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final totalMonth = repo.totalBetween(
      startOfMonth,
      now.add(const Duration(days: 1)),
    );
    final byType = repo.totalsByType(
      startOfMonth,
      now.add(const Duration(days: 1)),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Sustainify'),
        actions: [
          IconButton(
            onPressed: () => context.push('/insights'),
            icon: const Icon(Icons.insights_outlined),
            tooltip: 'Insights',
          ),
        ],
      ),
      floatingActionButton: _fab(context),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: 'Insights',
          ),
        ],
        onDestinationSelected: (i) {
          if (i == 1) context.push('/insights');
        },
        selectedIndex: 0,
      ),
      body: Stack(
        children: [
          // Gradient header background
          Container(
            height: 250,
            decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
          ),
          // Content
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 120, 16, 16),
            children: [
              // Hero card
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'This month emissions',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: totalMonth),
                            duration: const Duration(milliseconds: 800),
                            builder: (_, v, __) => Text(
                              '${v.toStringAsFixed(1)} kg CO₂e',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              StatChip(
                                label: 'Entries',
                                value: '${entries.length}',
                                icon: Icons.list_alt,
                              ),
                              StatChip(
                                label: 'Avg/day',
                                value: _avgThisMonth(
                                  totalMonth,
                                ).toStringAsFixed(1),
                                icon: Icons.today,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 88,
                      width: 88,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppTheme.accentGradient,
                      ),
                      child: const Center(
                        child: Icon(Icons.eco, color: Colors.black, size: 40),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Composition mini-pie
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Composition (month)',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 140,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          startDegreeOffset: -90,
                          centerSpaceRadius: 36,
                          sections: EntryType.values.map((t) {
                            final v = byType[t] ?? 0;
                            return PieChartSectionData(
                              value: v <= 0 ? 0.01 : v,
                              title: t.name,
                              radius: 46,
                              titleStyle: const TextStyle(fontSize: 10),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Recent entries',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              if (entries.isEmpty)
                GlassCard(
                  child: Row(
                    children: const [
                      Icon(Icons.info_outline),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'No entries yet — use the + button to add your first log.',
                        ),
                      ),
                    ],
                  ),
                ),
              ...entries
                  .take(20)
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Icon(_iconFor(e.type)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${e.type.name} • ${e.label}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${e.amount}  •  ${e.timestamp.toLocal()}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${e.kgCO2e.toStringAsFixed(2)} kg',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }

  double _avgThisMonth(double totalMonth) {
    final now = DateTime.now();
    final days = DateTime(now.year, now.month + 1, 0).day;
    return totalMonth / days;
  }

  IconData _iconFor(EntryType t) {
    switch (t) {
      case EntryType.transport:
        return Icons.directions_car;
      case EntryType.energy:
        return Icons.bolt;
      case EntryType.food:
        return Icons.restaurant;
      case EntryType.waste:
        return Icons.delete;
    }
  }

  Widget _fab(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        final value = await showMenu<String>(
          context: context,
          position: const RelativeRect.fromLTRB(200, 500, 20, 100),
          items: const [
            PopupMenuItem(
              value: 'transport',
              child: ListTile(
                leading: Icon(Icons.directions_car),
                title: Text('Add transport'),
              ),
            ),
            PopupMenuItem(
              value: 'energy',
              child: ListTile(
                leading: Icon(Icons.bolt),
                title: Text('Add energy'),
              ),
            ),
            PopupMenuItem(
              value: 'food',
              child: ListTile(
                leading: Icon(Icons.restaurant),
                title: Text('Add food'),
              ),
            ),
          ],
        );

        if (value == 'transport') context.push('/add/transport');
        if (value == 'energy') context.push('/add/energy');
        if (value == 'food') context.push('/add/food');
      },
      icon: const Icon(Icons.add),
      label: const Text('Add'),
    );
  }
}
