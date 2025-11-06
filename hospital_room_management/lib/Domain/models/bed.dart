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

  Map<String, dynamic> toJson() => {
        'bedNumber': bedNumber,
        'room': room.toJson(),
        'status': status,
      };

  factory Bed.fromJson(Map<String, dynamic> json) => Bed(
        bedNumber: json['bedNumber'],
        room: Room.fromJson(json['room']),
        status: json['status'] ?? 'Available',
      );

  @override
  String toString() => 'Bed($bedNumber - ${room.roomNumber}, $status)';
}
