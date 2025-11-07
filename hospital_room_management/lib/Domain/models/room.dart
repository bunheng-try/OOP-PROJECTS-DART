import 'bed.dart';

class Room {
  final String roomNumber;
  final String type; // General, ICU, Private
  final int floor;
  final int capacity;
  final List<Bed> beds;

  Room({
    required this.roomNumber,
    required this.type,
    required this.floor,
    required this.capacity,
    List<Bed>? beds,
  }) : beds = beds ?? [];

  Map<String, dynamic> toJson() => {
        'roomNumber': roomNumber,
        'type': type,
        'floor': floor,
        'capacity': capacity,
        // Serialize beds nested inside room (beds do not include room)
        'beds': beds.map((b) => b.toJson()).toList(),
      };

  factory Room.fromJson(Map<String, dynamic> json) {
    // Create the room first, then populate bed objects using this room as parent
    final room = Room(
      roomNumber: json['roomNumber'],
      type: json['type'],
      floor: json['floor'],
      capacity: json['capacity'],
      beds: [],
    );

    final bedsJson = json['beds'] as List<dynamic>?;
    if (bedsJson != null) {
      final parsedBeds = bedsJson.map((bj) => Bed.fromJson(bj as Map<String, dynamic>, room)).toList();
      return Room(
        roomNumber: room.roomNumber,
        type: room.type,
        floor: room.floor,
        capacity: room.capacity,
        beds: parsedBeds,
      );
    }

    return room;
  }

  @override
  String toString() => 'Room($roomNumber - $type, cap: $capacity)';
}
