// lib/models/penalty.dart
import 'package:hive/hive.dart';

@HiveType(typeId: 5)
class Penalty {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String roommateId;
  @HiveField(2)
  final String? choreId;
  @HiveField(3)
  final int amount; // points for now
  @HiveField(4)
  final String reason;
  @HiveField(5)
  final DateTime createdAt;

  const Penalty({
    required this.id,
    required this.roommateId,
    this.choreId,
    required this.amount,
    required this.reason,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) => other is Penalty && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class PenaltyAdapter extends TypeAdapter<Penalty> {
  @override
  final int typeId = 5;

  @override
  void write(BinaryWriter writer, Penalty obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.roommateId)
      ..writeBool(obj.choreId != null)
      ..writeString(obj.choreId ?? '')
      ..writeInt(obj.amount)
      ..writeString(obj.reason)
      ..writeInt(obj.createdAt.millisecondsSinceEpoch);
  }

  @override
  Penalty read(BinaryReader reader) {
    final id = reader.readString();
    final roommateId = reader.readString();
    final hasChore = reader.readBool();
    final choreId = reader.readString();
    final amount = reader.readInt();
    final reason = reader.readString();
    final createdMs = reader.readInt();

    return Penalty(
      id: id,
      roommateId: roommateId,
      choreId: hasChore ? choreId : null,
      amount: amount,
      reason: reason,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdMs),
    );
  }
}
