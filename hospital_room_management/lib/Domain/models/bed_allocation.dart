import 'enums.dart';
import 'bed.dart';
import 'patient.dart';

class BedAllocation {
  final String allocationId;
  final String patientId;
  final String bedNumber;
  final DateTime startDate;
  AllocationStatus status;

  BedAllocation({
    required this.allocationId,
    required this.patientId,
    required this.bedNumber,
    required this.startDate,
    this.status = AllocationStatus.Active,
  });

  Map<String, dynamic> toJson() => {
        'allocationId': allocationId,
        'patientId': patientId,
        'bedNumber': bedNumber,
        'startDate': startDate.toIso8601String(),
        'status': status.name,
      };

  factory BedAllocation.fromJson(Map<String, dynamic> json) => BedAllocation(
        allocationId: json['allocationId'],
        patientId: json['patientId'],
        bedNumber: json['bedNumber'],
        startDate: DateTime.parse(json['startDate']),
        status: AllocationStatus.values
            .firstWhere((e) => e.name == json['status']),
      );
}
