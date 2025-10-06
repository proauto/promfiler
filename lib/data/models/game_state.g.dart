// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameStateAdapter extends TypeAdapter<GameState> {
  @override
  final int typeId = 0;

  @override
  GameState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameState(
      currentDay: fields[0] as int,
      currentTime: fields[1] as DateTime,
      tokenBalance: fields[2] as int,
      readEmailIds: (fields[3] as List).cast<String>(),
      unlockedEvidenceIds: (fields[4] as List).cast<String>(),
      suspectNotes: (fields[5] as Map).cast<String, String>(),
      completedEnhancedInvestigations: (fields[6] as List).cast<String>(),
      canSubmitAnswer: fields[7] as bool,
      submittedSuspect: fields[8] as String?,
      requestedEnhancedInvestigations: (fields[9] as List).cast<String>(),
      emailEnhancedFiles: (fields[10] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as List).cast<String>())),
      day5EnhancedFilesToDeliver: (fields[11] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, GameState obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.currentDay)
      ..writeByte(1)
      ..write(obj.currentTime)
      ..writeByte(2)
      ..write(obj.tokenBalance)
      ..writeByte(3)
      ..write(obj.readEmailIds)
      ..writeByte(4)
      ..write(obj.unlockedEvidenceIds)
      ..writeByte(5)
      ..write(obj.suspectNotes)
      ..writeByte(6)
      ..write(obj.completedEnhancedInvestigations)
      ..writeByte(7)
      ..write(obj.canSubmitAnswer)
      ..writeByte(8)
      ..write(obj.submittedSuspect)
      ..writeByte(9)
      ..write(obj.requestedEnhancedInvestigations)
      ..writeByte(10)
      ..write(obj.emailEnhancedFiles)
      ..writeByte(11)
      ..write(obj.day5EnhancedFilesToDeliver);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
