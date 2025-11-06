import 'dart:io';
import '../Domain/models/room.dart';
import '../Domain/models/bed.dart';
import '../Domain/models/patient.dart';
import '../Domain/services/allocation_service.dart';

void main() {
  final service = AllocationService();

  // Add sample rooms and beds
  final r1 = Room(roomNumber: 'R1', type: 'General', floor: 1, capacity: 2);
  final r2 = Room(roomNumber: 'ICU1', type: 'ICU', floor: 1, capacity: 1);
  service.addRoom(r1);
  service.addRoom(r2);

  service.addBed(Bed(bedNumber: 'B1', room: r1));
  service.addBed(Bed(bedNumber: 'B2', room: r1));
  service.addBed(Bed(bedNumber: 'B3', room: r2));

  print('🏥 Hospital Bed Allocation System');
  while (true) {
    print('\n1) Register Patient');
    print('2) Show Available Beds');
    print('3) Allocate Bed');
    print('4) Show Active Allocations');
    print('5) Discharge Patient');
    print('0) Exit');
    stdout.write('> ');
    final input = stdin.readLineSync();

    if (input == '0') break;

    switch (input) {
      case '1':
        stdout.write('Patient ID: ');
        final id = stdin.readLineSync()!;
        stdout.write('Name: ');
        final name = stdin.readLineSync()!;
        stdout.write('Age: ');
        final age = int.parse(stdin.readLineSync()!);
        stdout.write('Condition: ');
        final condition = stdin.readLineSync()!;
        stdout.write('Priority (Low/Medium/High): ');
        final priority = stdin.readLineSync()!;

        service.registerPatient(Patient(
          patientId: id,
          name: name,
          age: age,
          medicalCondition: condition,
          priority: priority,
        ));
        print('✅ Patient registered!');
        break;

      case '2':
        final beds = service.findAvailableBeds();
        if (beds.isEmpty) {
          print('❌ No available beds.');
        } else {
          print('Available Beds:');
          for (var b in beds) print('- ${b.bedNumber} (${b.room.type})');
        }
        break;

      case '3':
        stdout.write('Patient ID: ');
        final pid = stdin.readLineSync()!;
        final patient = service.patients.firstWhere(
            (p) => p.patientId == pid,
            orElse: () => throw Exception('Patient not found'));
        stdout.write('Bed number: ');
        final bedNum = stdin.readLineSync()!;
        try {
          final alloc = service.allocateBed(bedNumber: bedNum, patient: patient);
          print('✅ Bed allocated: ${alloc.bed.bedNumber} -> ${alloc.patient.name}');
        } catch (e) {
          print('⚠️ Error: $e');
        }
        break;

      case '4':
        final active = service.activeAllocations;
        if (active.isEmpty) print('No active allocations.');
        for (var a in active) print(a);
        break;

      case '5':
        stdout.write('Enter allocation ID: ');
        final id = stdin.readLineSync()!;
        try {
          service.discharge(id);
          print('✅ Discharged successfully!');
        } catch (e) {
          print('⚠️ Error: $e');
        }
        break;

      default:
        print('Invalid choice.');
    }
  }
}
