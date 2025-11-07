import '../domain/models/room.dart';
import 'json_storage.dart';

class RoomRepository {
  final storage = JsonStorage();
  final String file = 'data/rooms.json';

  Future<List<Room>> getAllRooms() async {
    final data = await storage.readJson(file);
    return data.map((e) => Room.fromJson(e)).toList();
  }

  Future<void> addRoom(Room room) async {
    final rooms = await getAllRooms();
    rooms.add(room);
    await storage.saveJson(file, rooms.map((e) => e.toJson()).toList());
  }
}
