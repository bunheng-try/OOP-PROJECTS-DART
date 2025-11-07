import '../../Data/JSON_STORAGE.dart';
import '../models/room.dart';
import '../models/bed.dart';
import '../models/patient.dart';
import '../models/bed_allocation.dart';

class AllocationService {
  final List<Room> rooms = [];
  final List<Bed> beds = [];
  final List<Patient> patients = [];
  final List<BedAllocation> allocations = [];

  final storage = JSONStorage("../../lib/Data/json_data");

  void addBed(Bed bed) {
    beds.add(bed);
    // Ensure room is registered and the bed is part of the room.beds list
    final idx = rooms.indexWhere((r) => r.roomNumber == bed.room.roomNumber);
    if (idx == -1) {
      // If room not present, add the room and attach the bed
      final newRoom = bed.room;
      newRoom.beds.add(bed);
      rooms.add(newRoom);
    } else {
      rooms[idx].beds.add(bed);
    }
  }

  void registerPatient(Patient patient) {
    if (patients.any((p) => p.patientId == patient.patientId)) {
      throw Exception('Patient ID already exists');
    }
    patients.add(patient);
  }

  List<BedAllocation> get activeAllocations => 
      allocations.where((a) => a.status == 'Active').toList();

  BedAllocation allocateBed({required String bedNumber, required Patient patient}) {
    final bed = beds.firstWhere(
      (b) => b.bedNumber == bedNumber,
      orElse: () => throw Exception('Bed not found'),
    );

    if (!bed.isAvailable) {
      throw Exception('Bed not available');
    }

    // Check if ICU patient is getting ICU bed
    if (patient.medicalCondition.toLowerCase().contains('icu') && 
        bed.room.type != 'ICU') {
      throw Exception('ICU patient must be allocated to an ICU bed');
    }

    // Check room capacity
    final activeInRoom = activeAllocations
        .where((a) => a.bed.room.roomNumber == bed.room.roomNumber)
        .length;
    
    if (activeInRoom >= bed.room.capacity) {
      throw Exception('Room capacity exceeded');
    }
    
    bed.status = 'Occupied';
    final allocation = BedAllocation(
      allocationId: DateTime.now().millisecondsSinceEpoch.toString(),
      bed: bed,
      patient: patient,
      startDate: DateTime.now(),
    );
    allocations.add(allocation);
    saveAll();
    return allocation;
  }

  void discharge(String allocationId) {
    final allocation = allocations.firstWhere(
      (a) => a.allocationId == allocationId,
      orElse: () => throw Exception('Allocation not found'),
    );
    
    allocation.complete();
    allocation.bed.status = 'Available';
    saveAll();
  }

  Future<void> saveAll() async {
    // Persist rooms (with nested beds) to a single file `rooms.json`.
    await storage.saveList("../../Data/json_data/rooms.json", rooms.map((e) => e.toJson()).toList());
    await storage.saveList("../../Data/json_data/patients.json", patients.map((e) => e.toJson()).toList());
    await storage.saveList("../../Data/json_data/allocations.json", allocations.map((e) => e.toJson()).toList());
  }

  Future<void> loadAll() async {
    // Load rooms.json (rooms include nested beds). If not found, fallback to
    // legacy beds.json format.
    final roomsList = await storage.readList("../../Data/json_data/rooms.json");
    final p = await storage.readList("../../Data/json_data/patients.json");
    final a = await storage.readList("../../Data/json_data/allocations.json");

    if (roomsList != null) {
      for (var rj in roomsList) {
        final room = Room.fromJson(rj);
        rooms.add(room);
        // add beds from room
        for (var bed in room.beds) {
          beds.add(bed);
        }
      }
    } else {
      // Backwards compatibility: read beds.json as a list of beds with embedded room
      final b = await storage.readList("../../Data/json_data/rooms.json");
      if (b != null) {
        for (var bedJson in b) {
          final bed = Bed.fromJson(bedJson);
          beds.add(bed);
          if (!rooms.any((r) => r.roomNumber == bed.room.roomNumber)) {
            rooms.add(bed.room);
          }
        }
      }
    }

    if (p != null) {
      for (var pj in p) {
        final patient = Patient.fromJson(pj);
        patients.add(patient);
      }
    }

    if (a != null) {
      for (var aj in a) {
        // Reconstruct patient reference: prefer existing Patient instance
        final patientJson = aj['patient'];
        Patient patient = patients.firstWhere(
            (p) => p.patientId == patientJson['patientId'],
            orElse: () {
          final newP = Patient.fromJson(patientJson);
          patients.add(newP);
          return newP;
        });

        // Reconstruct bed reference: prefer existing Bed instance by bedNumber
        final bedJson = aj['bed'];
        Bed bed = beds.firstWhere((b) => b.bedNumber == bedJson['bedNumber'], orElse: () {
          final newBed = Bed.fromJson(bedJson);
          beds.add(newBed);
          if (!rooms.any((r) => r.roomNumber == newBed.room.roomNumber)) {
            rooms.add(newBed.room);
          }
          return newBed;
        });

        // Create allocation instance using stored dates/status
        final allocation = BedAllocation.fromJson(aj);

        // But replace the nested patient/bed with our canonical instances
        final fixedAllocation = BedAllocation(
          allocationId: allocation.allocationId,
          patient: patient,
          bed: bed,
          startDate: allocation.startDate,
          endDate: allocation.endDate,
          status: allocation.status,
        );

        allocations.add(fixedAllocation);
      }
    }
  }
}
