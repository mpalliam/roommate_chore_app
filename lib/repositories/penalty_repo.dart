// lib/repositories/penalty_repo.dart
import 'package:hive/hive.dart';
import '../models/penalty.dart';
import '../services/storage_service.dart';

class PenaltyRepo {
  final Box<Penalty> _box;

  PenaltyRepo(StorageService store) : _box = store.penalties;

  Future<void> create(Penalty p) async {
    if (_box.containsKey(p.id)) {
      throw StateError('Penalty with id ${p.id} already exists');
    }
    await _box.put(p.id, p);
  }

  Future<void> upsert(Penalty p) async {
    await _box.put(p.id, p);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  Penalty? getById(String id) => _box.get(id);

  List<Penalty> getAll() {
    final items = _box.values.toList(growable: false);
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  List<Penalty> byRoommate(String roommateId) =>
      getAll().where((p) => p.roommateId == roommateId).toList();
}
