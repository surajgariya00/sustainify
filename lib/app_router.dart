import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/home/home_screen.dart';
import 'features/insights/insights_screen.dart';
import 'features/add_entry/add_transport_entry_screen.dart';
import 'features/add_entry/add_energy_entry_screen.dart';
import 'features/add_entry/add_food_entry_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/insights', builder: (_, __) => const InsightsScreen()),
    GoRoute(
      path: '/add/transport',
      builder: (_, __) => const AddTransportEntryScreen(),
    ),
    GoRoute(
      path: '/add/energy',
      builder: (_, __) => const AddEnergyEntryScreen(),
    ),
    GoRoute(path: '/add/food', builder: (_, __) => const AddFoodEntryScreen()),
  ],
);
