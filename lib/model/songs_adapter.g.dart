// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'songs_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongAdapterAdapter extends TypeAdapter<SongAdapter> {
  @override
  final int typeId = 1;

  @override
  SongAdapter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongAdapter(
      id: fields[0] as int?,
      song: fields[1] as String?,
      artist: fields[2] as String?,
      duration: fields[3] as int?,
      uri: fields[4] as String?,
      playCount: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, SongAdapter obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.song)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.uri)
      ..writeByte(5)
      ..write(obj.playCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongAdapterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
