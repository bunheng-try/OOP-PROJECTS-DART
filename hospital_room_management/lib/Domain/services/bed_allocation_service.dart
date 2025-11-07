import '../../data/room_repository.dart';
import '../models/bed.dart';
import '../models/enums.dart';

class BedAllocationService {
  final RoomRepository roomRepo;

  BedAllocationService(this.roomRepo);

  String assignPatientToBed(String bedNumber, String patientId) {
    final bed = roomRepo.findBed(bedNumber);
    if (bed == null) {
      return 'Bed does not exist!';
    }
    if (bed.status != BedStatus.Available) {
      return 'Bed is not available!';
    }
    // Assign patient (expand as needed)
    bed.status = BedStatus.Occupied;
    // Save allocation record as needed
    return 'Patient $patientId assigned to bed $bedNumber.';
  }
}