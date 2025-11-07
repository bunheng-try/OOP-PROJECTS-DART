import 'enums.dart';

class Room {
  final String roomNumber;
  final RoomType type;
  final int floor;
  final int capacity;

  Room({
    required this.roomNumber,
    required this.type,
    required this.floor,
    required this.capacity,
  });

  Map<String, dynamic> toJson() => {
        'roomNumber': roomNumber,
        'type': type.name,
        'floor': floor,
        'capacity': capacity,
      };

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomNumber: json['roomNumber'],
      type: RoomType.values.firstWhere((e) => e.name == json['type']),
      floor: json['floor'],
      capacity: json['capacity'],
    );
  }
}
