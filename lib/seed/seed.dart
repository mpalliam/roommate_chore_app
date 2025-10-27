// lib/seed/seed.dart
import '../models/chore.dart';
import '../models/enums.dart';
import '../models/roommate.dart';
import '../repositories/chore_repo.dart';
import '../repositories/roommate_repo.dart';
import '../repositories/penalty_repo.dart';
import '../services/storage_service.dart';

Future<void> seedIfEmpty({
  required StorageService store,
  required RoommateRepo roommateRepo,
  required ChoreRepo choreRepo,
  required PenaltyRepo penaltyRepo,
}) async {
  final isEmpty =
      store.roommates.isEmpty && store.chores.isEmpty && store.penalties.isEmpty;

  if (!isEmpty) return;

  final now = DateTime.now();

  // Roommates
  final rm1 = Roommate(id: 'rm-${now.millisecondsSinceEpoch}-1', name: 'Alex', active: true, createdAt: now);
  final rm2 = Roommate(id: 'rm-${now.millisecondsSinceEpoch}-2', name: 'Sam', active: true, createdAt: now);
  final rm3 = Roommate(id: 'rm-${now.millisecondsSinceEpoch}-3', name: 'Jordan', active: true, createdAt: now);

  await roommateRepo.create(rm1);
  await roommateRepo.create(rm2);
  await roommateRepo.create(rm3);

  // Chores
  final today8pm = DateTime(now.year, now.month, now.day, 20);
  final tomorrow8pm = today8pm.add(const Duration(days: 1));
  // next Sunday 10am:
  final daysToSunday = (DateTime.sunday - now.weekday + 7) % 7;
  final nextSunday = DateTime(now.year, now.month, now.day).add(Duration(days: daysToSunday == 0 ? 7 : daysToSunday));
  final sunday10am = DateTime(nextSunday.year, nextSunday.month, nextSunday.day, 10);

  final c1 = Chore(
    id: 'ch-${now.millisecondsSinceEpoch}-1',
    title: 'Dishes',
    description: 'Load/unload dishwasher',
    frequency: ChoreFrequency.weekly,
    dueDate: today8pm,
    status: ChoreStatus.pending,
  );
  final c2 = Chore(
    id: 'ch-${now.millisecondsSinceEpoch}-2',
    title: 'Trash',
    description: 'Take out trash & recycling',
    frequency: ChoreFrequency.weekly,
    dueDate: tomorrow8pm,
    status: ChoreStatus.pending,
  );
  final c3 = Chore(
    id: 'ch-${now.millisecondsSinceEpoch}-3',
    title: 'Vacuum',
    description: 'Living room & hallway',
    frequency: ChoreFrequency.weekly,
    dueDate: sunday10am,
    status: ChoreStatus.pending,
  );

  await choreRepo.create(c1);
  await choreRepo.create(c2);
  await choreRepo.create(c3);
}
