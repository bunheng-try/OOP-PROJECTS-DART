import 'data/room_repository.dart';
import 'data/patient_repository.dart';
import 'domain/services/bed_allocation_service.dart';
import 'ui/console.dart';
import 'dart:io';

void main() async {
  try {
    print("Current directory: ${Directory.current.path}");
    
    // Load room data
    final roomRepo = await RoomRepository.loadFromJson('data/rooms_and_beds.json');
    
    // Initialize patient repository
    final patientRepo = PatientRepository();
    
    // Initialize services
    final service = BedAllocationService(roomRepo);
    
    // Initialize UI with all dependencies
    final ui = ConsoleUI(roomRepo, service, patientRepo);
    
    await ui.run();
  } catch (e) {
    print("Failed to start application: $e");
    print("Please check if the data files exist and are properly formatted.");
  }
}