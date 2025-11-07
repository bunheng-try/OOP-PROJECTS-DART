import '../data/room_repository.dart';
import '../data/patient_repository.dart';
import '../domain/services/bed_allocation_service.dart';
import '../domain/models/patient.dart';
import '../domain/models/enums.dart';
import '../domain/models/room.dart';
import '../domain/models/bed.dart';
import 'dart:io';

class ConsoleUI {
  final RoomRepository roomRepo;
  final BedAllocationService service;
  final PatientRepository patientRepo;

  ConsoleUI(this.roomRepo, this.service, this.patientRepo);

  Future<void> run() async {
    print("=== Hospital Bed Management System ===");

    while (true) {
      print("\n1. Register Patient");
      print("2. Allocate Bed");
      print("3. Release Bed");
      print("4. Show All Rooms & Beds");
      print("5. Show Available Beds");
      print("6. Show All Patients");
      print("7. Exit");
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
          showAvailableBeds();
          break;
        case '6':
          await showAllPatients();
          break;
        case '7':
          print("Goodbye!");
          return;
        default:
          print("Invalid option");
      }
    }
  }

  Future<void> registerPatient() async {
    try {
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
      
      // Save patient to JSON using PatientRepository
      await patientRepo.addPatient(patient);
      print("Patient $id registered successfully!");
    } catch (e) {
      print("Error registering patient: $e");
    }
  }

  Future<void> allocateBed() async {
    try {
      stdout.write("Patient ID: ");
      final pid = stdin.readLineSync()!;
      
      // Check if patient exists before allocating bed
      final patient = await patientRepo.findById(pid);
      if (patient == null) {
        print("Error: Patient $pid not found. Please register patient first.");
        return;
      }
      
      stdout.write("Bed Number: ");
      final bedNum = stdin.readLineSync()!;
      
      final result = service.assignPatientToBed(bedNum, pid);
      print(result);
    } catch (e) {
      print("Error during bed allocation: $e");
    }
  }

  Future<void> releaseBed() async {
    try {
      stdout.write("Bed Number to release: ");
      final bedNum = stdin.readLineSync()!;
      
      final result = service.releaseBed(bedNum);
      print(result);
    } catch (e) {
      print("Error releasing bed: $e");
    }
  }

  void showRoomsAndBeds() {
    if (roomRepo.rooms.isEmpty) {
      print("No rooms available.");
      return;
    }

    for (final room in roomRepo.rooms) {
      print(
          "Room ${room.roomNumber} (${room.type.name}), Floor: ${room.floor}, Capacity: ${room.capacity}");
      for (final bed in room.beds) {
        print("  Bed ${bed.bedNumber} - Status: ${bed.status.name}");
      }
      print(""); // Empty line for separation
    }
  }

  void showAvailableBeds() {
    final availableBeds = service.findAvailableBeds();
    
    if (availableBeds.isEmpty) {
      print("No available beds found.");
      return;
    }

    print("Available Beds (${availableBeds.length}):");
    
    // Group by room
    for (final room in roomRepo.rooms) {
      final availableBedsInRoom = room.beds.where((bed) => bed.status == BedStatus.Available).toList();
      if (availableBedsInRoom.isNotEmpty) {
        print("Room ${room.roomNumber} (${room.type.name}):");
        for (final bed in availableBedsInRoom) {
          print("  - Bed ${bed.bedNumber}");
        }
      }
    }
  }

  Future<void> showAllPatients() async {
    try {
      final patients = await patientRepo.getAllPatients();
      
      if (patients.isEmpty) {
        print("No patients registered.");
        return;
      }

      print("Registered Patients (${patients.length}):");
      for (final patient in patients) {
        print("  ID: ${patient.patientId}, Name: ${patient.name}, Age: ${patient.age}, Condition: ${patient.medicalCondition}, Priority: ${patient.priority.name}");
      }
    } catch (e) {
      print("Error loading patients: $e");
    }
  }

  Room? _findRoomByBed(Bed targetBed) {
    for (final room in roomRepo.rooms) {
      for (final bed in room.beds) {
        if (bed.bedNumber == targetBed.bedNumber) {
          return room;
        }
      }
    }
    return null;
  }
}