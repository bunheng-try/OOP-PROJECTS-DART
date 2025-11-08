import 'package:test/test.dart';
import '../lib/domain/models/bed.dart';
import '../lib/domain/models/patient.dart';
import '../lib/domain/models/enums.dart';
import '../lib/domain/models/bed_allocation.dart';

void main() {
  test('Allocate a bed to a patient', () {
    // Remove roomNumber parameter since Bed doesn't have it
    final bed = Bed(bedNumber: 'B1'); // Fixed: removed roomNumber
    final patient = Patient(
        patientId: 'P1',
        name: 'Alice',
        age: 30,
        medicalCondition: 'Fever',
        priority: PatientPriority.Low);
    final allocation = BedAllocation(
        allocationId: 'A1',
        patientId: patient.patientId,
        bedNumber: bed.bedNumber,
        startDate: DateTime.now());

    expect(bed.status, BedStatus.Available);
    expect(allocation.patientId, equals('P1'));
  });
}