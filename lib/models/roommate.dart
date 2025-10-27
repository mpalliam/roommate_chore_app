// lib/models/roommate.dart
import 'package:hive/hive.dart';

//part 'roommate.g.dart'; // (Not using codegen here, but harmless if present)

@HiveType(typeId: 3) // annotation is optional for manual adapter; kept for clarity
class Roommate {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final bool active;

  @HiveField(3)
  final DateTime createdAt;

  const Roommate({
    required this.id,
    required this.name,
    required this.active,
    required this.createdAt,
  });

  Roommate copyWith({
    String? id,
    String? name,
    bool? active,
    DateTime? createdAt,
  }) {
    return Roommate(
      id: id ?? this.id,
      name: name ?? this.name,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => other is Roommate && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// Manual adapter so we don't need code generation.
class RoommateAdapter extends TypeAdapter<Roommate> {
  @override
  final int typeId = 3;

  @override
  void write(BinaryWriter writer, Roommate obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.name)
      ..writeBool(obj.active)
      ..writeInt(obj.createdAt.millisecondsSinceEpoch);
  }

  @override
  Roommate read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final active = reader.readBool();
    final createdMs = reader.readInt();
    return Roommate(
      id: id,
      name: name,
      active: active,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdMs),
    );
  }
}
