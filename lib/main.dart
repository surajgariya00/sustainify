import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'theme/app_theme.dart';
import 'app_router.dart';
import 'storage/hive_boxes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Boxes.init();
  runApp(const ProviderScope(child: SustainifyApp()));
}

class SustainifyApp extends StatelessWidget {
  const SustainifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sustainify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      routerConfig: router,
    );
  }
}
