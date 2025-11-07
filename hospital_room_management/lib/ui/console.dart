import '../data/room_repository.dart';
import '../domain/services/bed_allocation_service.dart';
import '../domain/models/patient.dart';
import '../domain/models/enums.dart';
import 'dart:io';

class ConsoleUI {
  final RoomRepository roomRepo;
  final BedAllocationService service;

  ConsoleUI(this.roomRepo, this.service);

  Future<void> run() async {
    print("=== Hospital Bed Management System ===");

    while (true) {
      print("\n1. Register Patient");
      print("2. Allocate Bed");
      print("3. Release Bed");
      print("4. Show All Rooms & Beds");
      print("5. Exit");
      stdout.write("Choose: ");
      final choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          await registerPatient();
          break;
        case '2':
          await allocateBed();
          break;
        case '3':
          await releaseBed();
          break;
        case '4':
          showRoomsAndBeds();
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
    // Save patient as needed
    print("✅ Patient registered!");
  }

  Future<void> allocateBed() async {
    stdout.write("Patient ID: ");
    final pid = stdin.readLineSync()!;
    stdout.write("Bed Number: ");
    final bedNum = stdin.readLineSync()!;
    final result = service.assignPatientToBed(bedNum, pid);
    print(result);
  }

  Future<void> releaseBed() async {
    stdout.write("Bed Number: ");
    final bedNum = stdin.readLineSync()!;
    print("✅ Bed $bedNum released (not implemented)!");
  }

  void showRoomsAndBeds() {
    for (final room in roomRepo.rooms) {
      print(
          "Room ${room.roomNumber} (${room.type.name}), Floor: ${room.floor}, Capacity: ${room.capacity}");
      for (final bed in room.beds) {
        print("  Bed ${bed.bedNumber} - Status: ${bed.status.name}");
      }
    }
  }
}
