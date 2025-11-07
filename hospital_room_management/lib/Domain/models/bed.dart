import 'enums.dart';

class Bed {
  final String bedNumber;
  BedStatus status;

  Bed({required this.bedNumber, this.status = BedStatus.Available});

  factory Bed.fromJson(Map<String, dynamic> json) => Bed(
        bedNumber: json['bedNumber'],
        status: BedStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => BedStatus.Available,
        ),
      );

  Map<String, dynamic> toJson() => {
        'bedNumber': bedNumber,
        'status': status.name,
      };
}