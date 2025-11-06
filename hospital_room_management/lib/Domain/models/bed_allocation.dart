import 'bed.dart';
import 'patient.dart';

class BedAllocation {
  final String allocationId;
  final Patient patient;
  final Bed bed;
  final DateTime startDate;
  String status; // Active, Completed

  BedAllocation({
    required this.allocationId,
    required this.patient,
    required this.bed,
    required this.startDate,
    this.status = 'Active',
  });

  Map<String, dynamic> toJson() => {
        'allocationId': allocationId,
        'patient': patient.toJson(),
        'bed': bed.toJson(),
        'startDate': startDate.toIso8601String(),
        'status': status,
      };

  factory BedAllocation.fromJson(Map<String, dynamic> json) => BedAllocation(
        allocationId: json['allocationId'],
        patient: Patient.fromJson(json['patient']),
        bed: Bed.fromJson(json['bed']),
        startDate: DateTime.parse(json['startDate']),
        status: json['status'] ?? 'Active',
      );

  @override
  String toString() =>
      'Allocation($allocationId): ${patient.name} -> ${bed.bedNumber} [${status}]';
}
