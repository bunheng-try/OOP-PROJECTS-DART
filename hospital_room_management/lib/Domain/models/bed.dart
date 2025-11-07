import 'room.dart';

class Bed {
  final String bedNumber;
  final Room room;
  String status; // Available, Occupied, Maintenance

  Bed({
    required this.bedNumber,
    required this.room,
    this.status = 'Available',
  });

  bool get isAvailable => status == 'Available';

  // When serializing beds nested inside a room we do NOT include the room
  // field to avoid duplication. The room->beds structure is authoritative
  // for persistence.
  Map<String, dynamic> toJson() => {
        'bedNumber': bedNumber,
        'status': status,
      };

  /// Serialize including the nested room object. Used when a full snapshot
  /// of the bed (including its room) is required (e.g. saving allocations).
  Map<String, dynamic> toJsonWithRoom() => {
        'bedNumber': bedNumber,
        'status': status,
        'room': room.toJson(),
      };

  // Bed.fromJson can accept an optional parentRoom. If parentRoom is
  // provided it will be used as the bed's room; otherwise it expects the
  // JSON to contain a 'room' object (legacy/standalone format).
  factory Bed.fromJson(Map<String, dynamic> json, [Room? parentRoom]) {
    final Room room = parentRoom ??
        (json['room'] != null ? Room.fromJson(json['room']) : throw Exception('Room information missing for Bed'));

    return Bed(
      bedNumber: json['bedNumber'],
      room: room,
      status: json['status'] ?? 'Available',
    );
  }

  @override
  String toString() => 'Bed($bedNumber - ${room.roomNumber}, $status)';
}
