// lib/repositories/chore_repo.dart
import 'package:hive/hive.dart';
import '../models/chore.dart';
import '../models/enums.dart';
import '../services/storage_service.dart';

class ChoreRepo {
  final Box<Chore> _box;

  ChoreRepo(StorageService store) : _box = store.chores;

  Future<void> create(Chore c) async {
    if (_box.containsKey(c.id)) {
      throw StateError('Chore with id ${c.id} already exists');
    }
    await _box.put(c.id, c);
  }

  Future<void> upsert(Chore c) async {
    await _box.put(c.id, c);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  Chore? getById(String id) => _box.get(id);

  List<Chore> getAll() {
    final items = _box.values.toList(growable: false);
    // pending first, then soonest due
    items.sort((a, b) {
      final statusCmp = a.status.index.compareTo(b.status.index);
      if (statusCmp != 0) return statusCmp;
      return a.dueDate.compareTo(b.dueDate);
    });
    return items;
  }

  List<Chore> dueBy(DateTime when) {
    return getAll().where((c) => c.status == ChoreStatus.pending && c.dueDate.isBefore(when.add(const Duration(seconds: 1)))).toList();
  }
}
