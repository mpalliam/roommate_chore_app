// lib/services/scheduler_service.dart
import '../repositories/roommate_repo.dart';
import '../repositories/chore_repo.dart';
import '../models/chore.dart';
import '../models/enums.dart';

/// Handles fair round-robin assignment of chores to active roommates.
/// Simple policy: for each pending chore, assign to the "next" active roommate.
/// We keep an in-memory cursor per chore for now (stateless between launches
/// is fine at MVP; later you can persist a cursor if needed).
class SchedulerService {
  final RoommateRepo _roommates;
  final ChoreRepo _chores;

  // In-memory cursors by choreId (index in active roommates list)
  final Map<String, int> _cursor = {};

  SchedulerService({
    required RoommateRepo roommateRepo,
    required ChoreRepo choreRepo,
  })  : _roommates = roommateRepo,
        _chores = choreRepo;

  /// Assigns the next active roommate to the given chore (if pending).
  /// Returns the updated Chore, or null if no assignment was made.
  Future<Chore?> assignNext(String choreId) async {
    final chore = _chores.getById(choreId);
    if (chore == null) return null;
    if (chore.status != ChoreStatus.pending) return chore;

    final active = _roommates.activeOnly();
    if (active.isEmpty) return chore; // nobody to assign

    // Try to continue from last cursor; else start at 0
    final idx = _cursor[choreId] ?? 0;

    // Find next roommate in a circular way
    final nextIdx = idx % active.length;
    final assignedRm = active[nextIdx];

    // Advance cursor for next time
    _cursor[choreId] = (nextIdx + 1) % active.length;

    final updated = chore.copyWith(assignedTo: assignedRm.id);
    await _chores.upsert(updated);
    return updated;
  }

  /// Assigns all pending chores (bulk).
  Future<void> assignAllPending() async {
    final all = _chores.getAll();
    for (final c in all) {
      if (c.status == ChoreStatus.pending) {
        await assignNext(c.id);
      }
    }
  }
}
