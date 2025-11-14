// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/main_scaffold.dart';
import 'services/storage_service.dart';
import 'repositories/roommate_repo.dart';
import 'repositories/chore_repo.dart';
import 'repositories/penalty_repo.dart';
import 'services/scheduler_service.dart';
import 'services/chore_service.dart';
import 'seed/seed.dart';
import 'state/app_state.dart';
import 'ui/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final store = StorageService();
  await store.init();

  final rRepo = RoommateRepo(store);
  final cRepo = ChoreRepo(store);
  final pRepo = PenaltyRepo(store);

  await seedIfEmpty(
    store: store,
    roommateRepo: rRepo,
    choreRepo: cRepo,
    penaltyRepo: pRepo,
  );

  final scheduler = SchedulerService(roommateRepo: rRepo, choreRepo: cRepo);
  final choreSvc  = ChoreService(choreRepo: cRepo, penaltyRepo: pRepo);

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(
        roommates: rRepo,
        chores: cRepo,
        penalties: pRepo,
        scheduler: scheduler,
        choreSvc: choreSvc,
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roommate App',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const MainScaffold(),
    );
  }
}
