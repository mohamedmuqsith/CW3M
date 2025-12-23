// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FoodModelAdapter extends TypeAdapter<FoodModel> {
  @override
  final int typeId = 0;

  @override
  FoodModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      price: fields[3] as double,
      categoryId: fields[4] as String,
      imageUrl: fields[5] as String,
      calories: fields[6] as int,
      protein: fields[7] as int,
      carbs: fields[8] as int,
      fat: fields[9] as int,
      isAvailable: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FoodModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.categoryId)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.calories)
      ..writeByte(7)
      ..write(obj.protein)
      ..writeByte(8)
      ..write(obj.carbs)
      ..writeByte(9)
      ..write(obj.fat)
      ..writeByte(10)
      ..write(obj.isAvailable);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
