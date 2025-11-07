import 'enums.dart';
import 'bed.dart';

class Room {
  final String roomNumber;
  final RoomType type;
  final int floor;
  final int capacity;
  final List<Bed> beds;

  Room({
    required this.roomNumber,
    required this.type,
    required this.floor,
    required this.capacity,
    required this.beds,
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        roomNumber: json['roomNumber'],
        type: RoomType.values.firstWhere((e) => e.name == json['type']),
        floor: json['floor'],
        capacity: json['capacity'],
        beds: (json['beds'] as List)
            .map((b) => Bed.fromJson(b))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'roomNumber': roomNumber,
        'type': type.name,
        'floor': floor,
        'capacity': capacity,
        'beds': beds.map((b) => b.toJson()).toList(),
      };
}