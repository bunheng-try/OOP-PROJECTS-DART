import '../../data/room_repository.dart';
import '../models/bed.dart';
import '../models/enums.dart';

class BedAllocationService {
  final RoomRepository roomRepo;

  BedAllocationService(this.roomRepo);

  String assignPatientToBed(String bedNumber, String patientId) {
    try {
      // 1. Find the bed
      final bed = roomRepo.findBed(bedNumber);
      if (bed == null) {
        return 'Bed $bedNumber does not exist!';
      }

      // 2. Check if bed is available
      if (bed.status != BedStatus.Available) {
        return 'Bed $bedNumber is not available (Current status: ${bed.status.name})!';
      }

      // 3. Update bed status
      bed.status = BedStatus.Occupied;
      
      return 'Patient $patientId assigned to bed $bedNumber successfully.';
    } catch (e) {
      return 'Error assigning patient to bed: $e';
    }
  }

  // Release bed functionality
  String releaseBed(String bedNumber) {
    try {
      final bed = roomRepo.findBed(bedNumber);
      if (bed == null) {
        return 'Bed $bedNumber does not exist!';
      }
      if (bed.status != BedStatus.Occupied) {
        return 'Bed $bedNumber is not occupied!';
      }
      
      bed.status = BedStatus.Available;
      return 'Bed $bedNumber released successfully.';
    } catch (e) {
      return 'Error releasing bed: $e';
    }
  }

  List<Bed> findAvailableBeds() {
    final availableBeds = <Bed>[];
    for (final room in roomRepo.rooms) {
      for (final bed in room.beds) {
        if (bed.status == BedStatus.Available) {
          availableBeds.add(bed);
        }
      }
    }
    return availableBeds;
  }

  // Find beds by room type
  List<Bed> findBedsByRoomType(RoomType roomType) {
    final beds = <Bed>[];
    for (final room in roomRepo.rooms) {
      if (room.type == roomType) {
        beds.addAll(room.beds);
      }
    }
    return beds;
  }
}