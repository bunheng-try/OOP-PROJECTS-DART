import '../data/bed_repository.dart';
import '../data/patient_repository.dart';
import '../data/allocation_repository.dart';
import '../domain/services/bed_allocation_service.dart';
import '../domain/models/patient.dart';
import '../domain/models/enums.dart';
import '../domain/models/bed.dart';
import 'dart:io';
class ConsoleUI {
  final bedRepo = BedRepository();
  final patientRepo = PatientRepository();
  final allocationRepo = AllocationRepository();

  late final BedAllocationService service;

  ConsoleUI() {
    service = BedAllocationService(bedRepo, patientRepo, allocationRepo);
  }

  Future<void> run() async {
    print("=== Hospital Bed Management System ===");

    while (true) {
      print("\n1. Register Patient");
      print("2. Add Bed");
      print("3. Allocate Bed");
      print("4. Release Bed");
      print("5. Exit");
      stdout.write("Choose: ");
      final choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          await registerPatient();
          break;
        case '2':
          await addBed();
          break;
        case '3':
          await allocateBed();
          break;
        case '4':
          await releaseBed();
          break;
        case '5':
          print("Goodbye!");
          return;
        default:
          print("Invalid option");
      }
    }
  }

  Future<void> registerPatient() async {
    stdout.write("Enter Patient ID: ");
    final id = stdin.readLineSync()!;
    stdout.write("Name: ");
    final name = stdin.readLineSync()!;
    stdout.write("Age: ");
    final age = int.parse(stdin.readLineSync()!);
    stdout.write("Condition: ");
    final condition = stdin.readLineSync()!;
    stdout.write("Priority (Low/Medium/High): ");
    final priorityStr = stdin.readLineSync()!;
    final priority = PatientPriority.values
        .firstWhere((e) => e.name.toLowerCase() == priorityStr.toLowerCase());

    final patient = Patient(
      patientId: id,
      name: name,
      age: age,
      medicalCondition: condition,
      priority: priority,
    );
    await patientRepo.addPatient(patient);
    print("✅ Patient registered!");
  }

  Future<void> addBed() async {
    stdout.write("Enter Bed Number: ");
    final num = stdin.readLineSync()!;
    stdout.write("Room Number: ");
    final room = stdin.readLineSync()!;

    final bed = Bed(bedNumber: num, roomNumber: room);
    await bedRepo.addBed(bed);
    print("✅ Bed added!");
  }

  Future<void> allocateBed() async {
    stdout.write("Patient ID: ");
    final pid = stdin.readLineSync()!;
    stdout.write("Bed Number: ");
    final bedNum = stdin.readLineSync()!;
    final result = await service.allocateBed(pid, bedNum);
    print(result);
  }

  Future<void> releaseBed() async {
    stdout.write("Bed Number: ");
    final bedNum = stdin.readLineSync()!;
    final result = await service.releaseBed(bedNum);
    print(result);
  }
}
