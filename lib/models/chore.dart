// lib/models/chore.dart
import 'package:hive/hive.dart';
import 'enums.dart';

@HiveType(typeId: 4)
class Chore {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final ChoreFrequency frequency;

  @HiveField(4)
  final DateTime dueDate;

  @HiveField(5)
  final ChoreStatus status;

  @HiveField(6)
  final DateTime? lastCompletedAt;

  /// NEW (Phase 2): the current assignee’s roommateId, or null if unassigned.
  /// We’re NOT changing typeId. We’ll extend the adapter cautiously to remain
  /// backward compatible with existing saved data.
  final String? assignedTo;

  const Chore({
    required this.id,
    required this.title,
    this.description,
    required this.frequency,
    required this.dueDate,
    required this.status,
    this.lastCompletedAt,
    this.assignedTo,
  });

  Chore copyWith({
    String? id,
    String? title,
    String? description,
    ChoreFrequency? frequency,
    DateTime? dueDate,
    ChoreStatus? status,
    DateTime? lastCompletedAt,
    String? assignedTo,
  }) {
    return Chore(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      assignedTo: assignedTo ?? this.assignedTo,
    );
  }

  @override
  bool operator ==(Object other) => other is Chore && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class ChoreAdapter extends TypeAdapter<Chore> {
  @override
  final int typeId = 4;

  @override
  void write(BinaryWriter writer, Chore obj) {
    // Original 7 fields (from Phase 1) — keep order EXACT
    writer
      ..writeString(obj.id)
      ..writeString(obj.title)
      ..writeBool(obj.description != null)
      ..writeString(obj.description ?? '')
      ..writeByte(_freqToByte(obj.frequency))
      ..writeInt(obj.dueDate.millisecondsSinceEpoch)
      ..writeByte(_statusToByte(obj.status))
      ..writeBool(obj.lastCompletedAt != null)
      ..writeInt(obj.lastCompletedAt?.millisecondsSinceEpoch ?? 0);

    // NEW (Phase 2): append optional assignedTo, safely
    // Write a presence flag, then the string (or empty).
    final hasAssigned = obj.assignedTo != null && obj.assignedTo!.isNotEmpty;
    writer
      ..writeBool(hasAssigned)
      ..writeString(obj.assignedTo ?? '');
  }

  @override
  Chore read(BinaryReader reader) {
    // Read Phase 1 fields in the exact order they were written
    final id = reader.readString();
    final title = reader.readString();
    final hasDesc = reader.readBool();
    final desc = reader.readString();
    final freqCode = reader.readByte();
    final dueMs = reader.readInt();
    final statusCode = reader.readByte();
    final hasLast = reader.readBool();
    final lastMs = reader.readInt();

    String? assignedTo;

    // Backward-compat: Phase 1 data ends above. If the record was saved before
    // we added 'assignedTo', there will be no more bytes. Only read the extra
    // fields if bytes remain.
    if (reader.availableBytes >= 1) {
      final hasAssigned = reader.readBool();
      if (reader.availableBytes >= 1) {
        final assignedStr = reader.readString();
        assignedTo = hasAssigned ? assignedStr : null;
      }
    }

    return Chore(
      id: id,
      title: title,
      description: hasDesc ? desc : null,
      frequency: _byteToFreq(freqCode),
      dueDate: DateTime.fromMillisecondsSinceEpoch(dueMs),
      status: _byteToStatus(statusCode),
      lastCompletedAt: hasLast ? DateTime.fromMillisecondsSinceEpoch(lastMs) : null,
      assignedTo: assignedTo,
    );
  }

  int _freqToByte(ChoreFrequency f) {
    switch (f) {
      case ChoreFrequency.once:
        return 0;
      case ChoreFrequency.weekly:
        return 1;
      case ChoreFrequency.custom:
        return 2;
    }
  }

  ChoreFrequency _byteToFreq(int b) {
    switch (b) {
      case 0:
        return ChoreFrequency.once;
      case 1:
        return ChoreFrequency.weekly;
      case 2:
        return ChoreFrequency.custom;
      default:
        return ChoreFrequency.once;
    }
  }

  int _statusToByte(ChoreStatus s) {
    switch (s) {
      case ChoreStatus.pending:
        return 0;
      case ChoreStatus.done:
        return 1;
      case ChoreStatus.missed:
        return 2;
    }
  }

  ChoreStatus _byteToStatus(int b) {
    switch (b) {
      case 0:
        return ChoreStatus.pending;
      case 1:
        return ChoreStatus.done;
      case 2:
        return ChoreStatus.missed;
      default:
        return ChoreStatus.pending;
    }
  }
}
