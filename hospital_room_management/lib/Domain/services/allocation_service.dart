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

  final storage = JSONStorage("lib/Data/json_data");

  void addBed(Bed bed) {
    beds.add(bed);
    if (!rooms.any((r) => r.roomNumber == bed.room.roomNumber)) {
      rooms.add(bed.room);
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
    await storage.saveList("rooms.json", rooms.map((e) => e.toJson()).toList());
    await storage.saveList("beds.json", beds.map((e) => e.toJson()).toList());
    await storage.saveList("patients.json", patients.map((e) => e.toJson()).toList());
    await storage.saveList("allocations.json", allocations.map((e) => e.toJson()).toList());
  }

  Future<void> loadAll() async {
    final r = await storage.readList("rooms.json");
    final b = await storage.readList("beds.json");
    final p = await storage.readList("patients.json");
    final a = await storage.readList("allocations.json");

    if (r != null) rooms.addAll(r.map((e) => Room.fromJson(e)));
    if (b != null) beds.addAll(b.map((e) => Bed.fromJson(e)));
    if (p != null) patients.addAll(p.map((e) => Patient.fromJson(e)));
    if (a != null) allocations.addAll(a.map((e) => BedAllocation.fromJson(e)));
  }
}
