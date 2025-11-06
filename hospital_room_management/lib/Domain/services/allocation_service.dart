import 'dart:math';

import '../models/room.dart';
import '../models/bed.dart';
import '../models/patient.dart';
import '../models/bed_allocation.dart';

class AllocationService {
  final List<Room> rooms = [];
  final List<Bed> beds = [];
  final List<Patient> patients = [];
  final List<BedAllocation> allocations = [];

  String _generateId() {
  final random = Random();
  return (1000 + random.nextInt(9000)).toString(); 
}


  void addRoom(Room room) => rooms.add(room);
  void addBed(Bed bed) => beds.add(bed);
  void registerPatient(Patient patient) => patients.add(patient);

  List<Bed> findAvailableBeds({String? type}) {
    return beds.where((b) => b.isAvailable && (type == null || b.room.type == type)).toList();
  }

  int occupancy(Room room) =>
      allocations.where((a) => a.bed.room.roomNumber == room.roomNumber && a.status == 'Active').length;

  bool _roomHasSpace(Room room) => occupancy(room) < room.capacity;

  BedAllocation allocateBed({
    required String bedNumber,
    required Patient patient,
  }) {
    final bed = beds.firstWhere((b) => b.bedNumber == bedNumber, orElse: () => throw Exception('Bed not found'));
    if (!bed.isAvailable) throw Exception('Bed not available');

    // ICU patient must go to ICU bed
    if (patient.priority == 'High' || patient.medicalCondition.toLowerCase().contains('icu')) {
      if (bed.room.type != 'ICU') throw Exception('ICU patient requires ICU bed');
    }

    // Room capacity check
    if (!_roomHasSpace(bed.room)) {
      throw Exception('Room ${bed.room.roomNumber} is full');
    }

    final allocation = BedAllocation(
      allocationId: _generateId(),
      patient: patient,
      bed: bed,
      startDate: DateTime.now(),
    );

    bed.status = 'Occupied';
    allocations.add(allocation);
    return allocation;
  }

  void discharge(String allocationId) {
    final alloc = allocations.firstWhere((a) => a.allocationId == allocationId);
    alloc.status = 'Completed';
    alloc.bed.status = 'Available';
  }

  List<BedAllocation> get activeAllocations =>
      allocations.where((a) => a.status == 'Active').toList();
}
