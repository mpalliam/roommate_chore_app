// lib/services/chore_service.dart
import '../repositories/chore_repo.dart';
import '../repositories/penalty_repo.dart';
import '../models/chore.dart';
import '../models/enums.dart';
import '../models/penalty.dart';

/// Business actions on chores: mark done, mark missed, and roll to next cycle.
class ChoreService {
  final ChoreRepo _chores;
  final PenaltyRepo _penalties;

  ChoreService({
    required ChoreRepo choreRepo,
    required PenaltyRepo penaltyRepo,
  })  : _chores = choreRepo,
        _penalties = penaltyRepo;

  /// Mark a chore done (sets status, lastCompletedAt).
  Future<Chore?> markDone(String choreId) async {
    final chore = _chores.getById(choreId);
    if (chore == null) return null;

    final updated = chore.copyWith(
      status: ChoreStatus.done,
      lastCompletedAt: DateTime.now(),
    );
    await _chores.upsert(updated);
    return updated;
  }

  /// Mark a chore missed and apply a penalty to the current assignee (if any).
  /// Simple rule: missed chore = +1 point.
  Future<Chore?> markMissed(String choreId) async {
    final chore = _chores.getById(choreId);
    if (chore == null) return null;

    final updated = chore.copyWith(status: ChoreStatus.missed);
    await _chores.upsert(updated);

    if (chore.assignedTo != null) {
      final p = Penalty(
        id: 'pn-${DateTime.now().millisecondsSinceEpoch}',
        roommateId: chore.assignedTo!,
        choreId: chore.id,
        amount: 1,
        reason: 'Missed chore: ${chore.title}',
        createdAt: DateTime.now(),
      );
      await _penalties.create(p);
    }
    return updated;
  }

  /// For weekly chores: reset to pending, clear assignedTo, and set next due date
  /// by adding 7 days. (You can call this via a weekly job or after completion.)
  Future<Chore?> rolloverWeekly(String choreId) async {
    final chore = _chores.getById(choreId);
    if (chore == null) return null;
    if (chore.frequency != ChoreFrequency.weekly) return chore;

    final nextDue = chore.dueDate.add(const Duration(days: 7));
    final reset = chore.copyWith(
      status: ChoreStatus.pending,
      assignedTo: null,
      dueDate: nextDue,
    );
    await _chores.upsert(reset);
    return reset;
  }
}
