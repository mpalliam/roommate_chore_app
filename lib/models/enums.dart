// lib/models/enums.dart
import 'package:hive/hive.dart';

/// What cadence a chore follows.
enum ChoreFrequency { once, weekly, custom }

/// Where a chore stands right now.
enum ChoreStatus { pending, done, missed }

/// Hive needs adapters to save/load enums as small integers.
/// IMPORTANT: The mapping used in write() must match read().

class ChoreFrequencyAdapter extends TypeAdapter<ChoreFrequency> {
  @override
  final int typeId = 1; // unique across your whole app

  @override
  void write(BinaryWriter writer, ChoreFrequency value) {
    switch (value) {
      case ChoreFrequency.once:
        writer.writeByte(0);
        break;
      case ChoreFrequency.weekly:
        writer.writeByte(1);
        break;
      case ChoreFrequency.custom:
        writer.writeByte(2);
        break;
    }
  }

  @override
  ChoreFrequency read(BinaryReader reader) {
    final code = reader.readByte();
    switch (code) {
      case 0:
        return ChoreFrequency.once;
      case 1:
        return ChoreFrequency.weekly;
      case 2:
        return ChoreFrequency.custom;
      default:
        return ChoreFrequency.once; // safe default
    }
  }
}

class ChoreStatusAdapter extends TypeAdapter<ChoreStatus> {
  @override
  final int typeId = 2;

  @override
  void write(BinaryWriter writer, ChoreStatus value) {
    switch (value) {
      case ChoreStatus.pending:
        writer.writeByte(0);
        break;
      case ChoreStatus.done:
        writer.writeByte(1);
        break;
      case ChoreStatus.missed:
        writer.writeByte(2);
        break;
    }
  }

  @override
  ChoreStatus read(BinaryReader reader) {
    final code = reader.readByte();
    switch (code) {
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
