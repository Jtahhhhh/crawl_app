// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comic.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ComicsModelAdapter extends TypeAdapter<ComicsModel> {
  @override
  final int typeId = 3;

  @override
  ComicsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ComicsModel()
      ..image = fields[0] as String
      ..title = fields[1] as String
      ..linkDetail = fields[2] as String;
  }

  @override
  void write(BinaryWriter writer, ComicsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.linkDetail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComicsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChapterAdapter extends TypeAdapter<Chapter> {
  @override
  final int typeId = 4;

  @override
  Chapter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chapter(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Chapter obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.linkDetail)
      ..writeByte(2)
      ..write(obj.dateUpdate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChapterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ImgChapAdapter extends TypeAdapter<ImgChap> {
  @override
  final int typeId = 10;

  @override
  ImgChap read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImgChap(
      fields[0] as String,
      fields[1] as String,
    )..imagesmall = fields[2] as Uint8List;
  }

  @override
  void write(BinaryWriter writer, ImgChap obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.chapname)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.imagesmall);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImgChapAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChapterinfoAdapter extends TypeAdapter<Chapterinfo> {
  @override
  final int typeId = 11;

  @override
  Chapterinfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chapterinfo(
      fields[0] as String,
      (fields[1] as List).cast<Uint8List>(),
      fields[2] as DateTime,
    )..state = fields[3] as int;
  }

  @override
  void write(BinaryWriter writer, Chapterinfo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.chapname)
      ..writeByte(1)
      ..write(obj.listimg)
      ..writeByte(2)
      ..write(obj.dateupdate)
      ..writeByte(3)
      ..write(obj.state);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChapterinfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
