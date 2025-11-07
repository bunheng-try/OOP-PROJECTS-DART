import 'bed.dart';
import 'patient.dart';

class BedAllocation {
  final String allocationId;
  final Patient patient;
  final Bed bed;
  final DateTime startDate;
  DateTime? endDate;
  String status; // Active, Completed

  BedAllocation({
    required this.allocationId,
    required this.patient,
    required this.bed,
    required this.startDate,
    this.endDate,
    this.status = 'Active',
  });

  void complete() {
    status = 'Completed';
    endDate = DateTime.now();
  }

  String getDuration() {
    if (status == 'Active') {
      final duration = DateTime.now().difference(startDate);
      return _formatDuration(duration);
    } else if (endDate != null) {
      final duration = endDate!.difference(startDate);
      return _formatDuration(duration);
    }
    return 'Unknown';
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} days';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hours';
    } else {
      return '${duration.inMinutes} minutes';
    }
  }

  Map<String, dynamic> toJson() => {
        'allocationId': allocationId,
        'patient': patient.toJson(),
    // include full bed snapshot (with room) inside allocation JSON
    'bed': bed.toJsonWithRoom(),
        'startDate': startDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'status': status,
      };

  factory BedAllocation.fromJson(Map<String, dynamic> json) => BedAllocation(
        allocationId: json['allocationId'],
        patient: Patient.fromJson(json['patient']),
        bed: Bed.fromJson(json['bed']),
        startDate: DateTime.parse(json['startDate']),
        endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
        status: json['status'] ?? 'Active',
      );

  @override
  String toString() {
    final duration = getDuration();
    return 'Room: ${bed.room.roomNumber} (${bed.room.type}), Bed: ${bed.bedNumber}\n'
           'Duration: $duration\n'
           'Status: $status';
}
}