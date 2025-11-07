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
  stdout.write("Enter Patient ID (Ex: 001): ");
  final id = stdin.readLineSync()!;
  String name;
  while (true) {
    stdout.write("Name: ");
    name = stdin.readLineSync()!;
    if (RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
      break;
    } else {
      print(" Invalid name. Use letters and spaces only.");
    }
  }
  int age;
  while (true) {
    stdout.write("Age: ");
    final input = stdin.readLineSync()!;
    final parsed = int.tryParse(input);
    if (parsed != null && parsed >= 0 && parsed <= 100) {
      age = parsed;
      break;
    } else {
      print(" Invalid age. Enter a number between 0 and 100.");
    }
  }
  stdout.write("Condition: ");
  final condition = stdin.readLineSync()!;
  PatientPriority priority;
  while (true) {
    stdout.write("Priority (Low/Medium/High): ");
    final priorityStr = stdin.readLineSync()!;
    try {
      priority = PatientPriority.values.firstWhere(
        (e) => e.name.toLowerCase() == priorityStr.toLowerCase(),
      );
      break;
    } catch (e) {
      print(" Invalid priority. Please enter Low, Medium, or High.");
    }
  }

  final patient = Patient(
    patientId: id,
    name: name,
    age: age,
    medicalCondition: condition,
    priority: priority,
  );

  // Save patient as needed
  print(" Patient registered successfully!");
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
    print(" Bed $bedNum released (not implemented)!");
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
