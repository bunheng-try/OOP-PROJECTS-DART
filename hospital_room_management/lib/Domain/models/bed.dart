import 'enums.dart';
import 'room.dart';

class Bed {
  final String bedNumber;
  final String roomNumber;
  BedStatus status;

  Bed({
    required this.bedNumber,
    required this.roomNumber,
    this.status = BedStatus.Available,
  });

  Map<String, dynamic> toJson() => {
        'bedNumber': bedNumber,
        'roomNumber': roomNumber,
        'status': status.name,
      };

  factory Bed.fromJson(Map<String, dynamic> json) => Bed(
        bedNumber: json['bedNumber'],
        roomNumber: json['roomNumber'],
        status: BedStatus.values.firstWhere((e) => e.name == json['status']),
      );
}
