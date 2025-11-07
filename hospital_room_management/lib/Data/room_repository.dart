import 'dart:convert';
import 'dart:io';
import '../domain/models/room.dart';
import '../domain/models/bed.dart';
//AI generated code for room repository
class RoomRepository {
  final List<Room> rooms;

  RoomRepository._(this.rooms);

  static Future<RoomRepository> loadFromJson(String path) async {
    final file = File(path);
    final jsonString = await file.readAsString();
    final data = jsonDecode(jsonString);
    final rooms = (data['rooms'] as List)
        .map((r) => Room.fromJson(r))
        .toList();
    return RoomRepository._(rooms);
  }

  Bed? findBed(String bedNumber) {
    for (final room in rooms) {
      for (final bed in room.beds) {
        if (bed.bedNumber == bedNumber) {
          return bed;
        }
      }
    }
    return null;
  }

  bool bedExists(String bedNumber) => findBed(bedNumber) != null;
}