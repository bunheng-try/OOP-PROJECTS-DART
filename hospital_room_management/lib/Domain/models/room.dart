class Room {
  final String roomNumber;
  final String type; // General, ICU, Private
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
        'type': type,
        'floor': floor,
        'capacity': capacity,
      };

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        roomNumber: json['roomNumber'],
        type: json['type'],
        floor: json['floor'],
        capacity: json['capacity'],
      );

  @override
  String toString() => 'Room($roomNumber - $type, cap: $capacity)';
}
