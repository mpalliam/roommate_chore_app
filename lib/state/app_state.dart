// lib/state/app_state.dart
import 'package:flutter/foundation.dart';
import '../repositories/roommate_repo.dart';
import '../repositories/chore_repo.dart';
import '../repositories/penalty_repo.dart';
import '../services/scheduler_service.dart';
import '../services/chore_service.dart';
import '../models/chore.dart';
import '../models/roommate.dart';
import '../models/penalty.dart';
import '../models/enums.dart';

class AppState extends ChangeNotifier {
  final RoommateRepo roommates;
  final ChoreRepo chores;
  final PenaltyRepo penalties;
  final SchedulerService scheduler;
  final ChoreService choreSvc;

  AppState({
    required this.roommates,
    required this.chores,
    required this.penalties,
    required this.scheduler,
    required this.choreSvc,
  }) {
    reload();
  }

  // Cached lists for simple screens
  List<Roommate> _rms = [];
  List<Chore> _chs = [];
  List<Penalty> _pns = [];

  List<Roommate> get roommatesList => _rms;
  List<Chore> get choresList => _chs;
  List<Penalty> get penaltiesList => _pns;

  int get roommatesCount => _rms.length;
  int get choresCount => _chs.length;
  int get penaltiesCount => _pns.length;

  // Convenience: next 3 due pending chores
  List<Chore> get nextDue {
    final pending = _chs.where((c) => c.status == ChoreStatus.pending).toList();
    pending.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return pending.take(3).toList();
  }

  // Map a roommateId to a name (for lists)
  String nameFor(String? roommateId) {
    if (roommateId == null || roommateId.isEmpty) return '—';
    final i = _rms.indexWhere((r) => r.id == roommateId);
    return i == -1 ? 'Unknown' : _rms[i].name;
  }

  void reload() {
    _rms = roommates.getAll();
    _chs = chores.getAll();
    _pns = penalties.getAll();
    notifyListeners();
  }

  Future<void> assignAllPending() async {
    await scheduler.assignAllPending();
    reload();
  }

  // For future screens; handy to have here:
  Future<void> markDone(String choreId) async {
    await choreSvc.markDone(choreId);
    reload();
  }

  Future<void> markMissed(String choreId) async {
    await choreSvc.markMissed(choreId);
    reload();
  }
}
