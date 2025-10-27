// lib/repositories/roommate_repo.dart
import 'package:hive/hive.dart';
import '../models/roommate.dart';
import '../services/storage_service.dart';

class RoommateRepo {
  final Box<Roommate> _box;

  RoommateRepo(StorageService store) : _box = store.roommates;

  Future<void> create(Roommate m) async {
    if (_box.containsKey(m.id)) {
      throw StateError('Roommate with id ${m.id} already exists');
    }
    await _box.put(m.id, m);
  }

  Future<void> upsert(Roommate m) async {
    await _box.put(m.id, m);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  Roommate? getById(String id) => _box.get(id);

  List<Roommate> getAll() {
    final items = _box.values.toList(growable: false);
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  List<Roommate> activeOnly() => getAll().where((m) => m.active).toList();
}
