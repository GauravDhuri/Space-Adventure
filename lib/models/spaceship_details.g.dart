// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spaceship_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SpaceshipTypeAdapter extends TypeAdapter<SpaceshipType> {
  @override
  final int typeId = 1;

  @override
  SpaceshipType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SpaceshipType.blurryFace;
      case 1:
        return SpaceshipType.squanceInPeace;
      case 2:
        return SpaceshipType.anigma;
      default:
        return SpaceshipType.blurryFace;
    }
  }

  @override
  void write(BinaryWriter writer, SpaceshipType obj) {
    switch (obj) {
      case SpaceshipType.blurryFace:
        writer.writeByte(0);
        break;
      case SpaceshipType.squanceInPeace:
        writer.writeByte(1);
        break;
      case SpaceshipType.anigma:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpaceshipTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
