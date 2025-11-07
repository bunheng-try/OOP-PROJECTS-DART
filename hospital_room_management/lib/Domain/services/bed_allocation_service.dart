import '../../data/bed_repository.dart';
import '../../data/patient_repository.dart';
import '../../data/allocation_repository.dart';
import '../models/enums.dart';
import '../models/bed_allocation.dart';

class BedAllocationService {
  final BedRepository bedRepo;
  final PatientRepository patientRepo;
  final AllocationRepository allocationRepo;

  BedAllocationService(this.bedRepo, this.patientRepo, this.allocationRepo);

  Future<String> allocateBed(String patientId, String bedNumber) async {
    final bed = await bedRepo.findByBedNumber(bedNumber);
    if (bed == null || bed.status != BedStatus.Available) {
      return "❌ Bed not available.";
    }

    final patient = await patientRepo.findById(patientId);
    if (patient == null) return "❌ Patient not found.";

    bed.status = BedStatus.Occupied;
    await bedRepo.updateBed(bed);

    final allocation = BedAllocation(
      allocationId: DateTime.now().millisecondsSinceEpoch.toString(),
      patientId: patientId,
      bedNumber: bedNumber,
      startDate: DateTime.now(),
    );

    await allocationRepo.addAllocation(allocation);
    return "✅ Bed ${bed.bedNumber} allocated to ${patient.name}.";
  }

  Future<String> releaseBed(String bedNumber) async {
    final bed = await bedRepo.findByBedNumber(bedNumber);
    if (bed == null) return "❌ Bed not found.";

    bed.status = BedStatus.Available;
    await bedRepo.updateBed(bed);
    return "✅ Bed ${bed.bedNumber} is now available.";
  }
}
