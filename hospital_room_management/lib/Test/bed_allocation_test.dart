import 'package:test/test.dart';
import 'package:hospital_room_management/Domain/models/room.dart';
import 'package:hospital_room_management/Domain/models/bed.dart';
import 'package:hospital_room_management/Domain/models/patient.dart';
import 'package:hospital_room_management/Domain/services/allocation_service.dart';

void main() {
  group('Bed Allocation Logic', () {
    late AllocationService service;
    late Room genRoom;
    late Room icuRoom;

    setUp(() {
      service = AllocationService();
      genRoom = Room(roomNumber: 'G1', type: 'General', floor: 1, capacity: 2);
      icuRoom = Room(roomNumber: 'ICU1', type: 'ICU', floor: 1, capacity: 1);

      // Beds for general room
      service.addBed(Bed(bedNumber: 'B1', room: genRoom));
      service.addBed(Bed(bedNumber: 'B2', room: genRoom));

      // Bed for ICU room
      service.addBed(Bed(bedNumber: 'B3', room: icuRoom));
    });

    test('Allocates available bed', () {
      final p = Patient(
        patientId: 'P1',
        name: 'Alice',
        age: 25,
        medicalCondition: 'Flu',
        priority: 'Low',
      );
      service.registerPatient(p);

      final alloc = service.allocateBed(bedNumber: 'B1', patient: p);

      expect(alloc.bed.status, equals('Occupied'));
      expect(service.activeAllocations.length, equals(1));
    });

    test('ICU patient must get ICU bed', () {
      final p = Patient(
        patientId: 'P2',
        name: 'Bob',
        age: 40,
        medicalCondition: 'ICU Care',
        priority: 'High',
      );
      service.registerPatient(p);

      // Should throw error if trying to allocate non-ICU bed
      expect(() => service.allocateBed(bedNumber: 'B1', patient: p), throwsException);

      // Should work correctly on ICU bed
      final alloc = service.allocateBed(bedNumber: 'B3', patient: p);
      expect(alloc.bed.room.type, equals('ICU'));
      expect(alloc.status, equals('Active'));
    });

    test('Room capacity not exceeded', () {
      // General room (G1) has capacity 2 → only 2 patients allowed
      final p1 = Patient(patientId: 'P1', name: 'A', age: 20, medicalCondition: 'Cold', priority: 'Low');
      final p2 = Patient(patientId: 'P2', name: 'B', age: 30, medicalCondition: 'Flu', priority: 'Low');
      final p3 = Patient(patientId: 'P3', name: 'C', age: 22, medicalCondition: 'Cold', priority: 'Low');

      service.registerPatient(p1);
      service.registerPatient(p2);
      service.registerPatient(p3);

      // Add an extra bed in the same room to exceed capacity test
      service.addBed(Bed(bedNumber: 'B4', room: genRoom));

      // Fill up room capacity (2 patients)
      service.allocateBed(bedNumber: 'B1', patient: p1);
      service.allocateBed(bedNumber: 'B2', patient: p2);

      // Try to add one more patient in same room (even though extra bed exists)
      expect(() => service.allocateBed(bedNumber: 'B4', patient: p3), throwsException);
    });
  });
}
