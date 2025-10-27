// lib/services/storage_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../models/enums.dart';
import '../models/roommate.dart';
import '../models/chore.dart';
import '../models/penalty.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late final Box<Roommate> _roommates;
  late final Box<Chore> _chores;
  late final Box<Penalty> _penalties;

  Future<void> init() async {
    await Hive.initFlutter();

    // Register ALL adapters before opening any box.
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(ChoreFrequencyAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(ChoreStatusAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(RoommateAdapter());
    if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(ChoreAdapter());
    if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(PenaltyAdapter());

    _roommates = await Hive.openBox<Roommate>('roommates');
    _chores = await Hive.openBox<Chore>('chores');
    _penalties = await Hive.openBox<Penalty>('penalties');
  }

  Box<Roommate> get roommates => _roommates;
  Box<Chore> get chores => _chores;
  Box<Penalty> get penalties => _penalties;
}
