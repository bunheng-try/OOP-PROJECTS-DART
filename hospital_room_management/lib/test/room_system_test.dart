import 'package:test/test.dart';
import '../domain/models/bed.dart';
import '../domain/models/patient.dart';
import '../domain/models/enums.dart';
import '../domain/models/bed_allocation.dart';

void main() {
  test('Allocate a bed to a patient', () {
    final bed = Bed(bedNumber: 'B1', roomNumber: '101');
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
