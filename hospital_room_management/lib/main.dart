import 'data/room_repository.dart';
import 'domain/services/bed_allocation_service.dart';
import 'ui/console.dart';
import 'dart:io';

void main() async {
  print("Current directory: ${Directory.current.path}");
  final roomRepo = await RoomRepository.loadFromJson('data/rooms_and_beds.json');
  final service = BedAllocationService(roomRepo);
  final ui = ConsoleUI(roomRepo, service);
  await ui.run();
}
