import '../domain/models/bed.dart';
import 'json_storage.dart';
//AI generated code for bed repository
class BedRepository {
  final storage = JsonStorage();
  final String file = 'data/beds.json';

  Future<List<Bed>> getAllBeds() async {
    final data = await storage.readJson(file);
    return data.map((e) => Bed.fromJson(e)).toList();
  }

  Future<void> addBed(Bed bed) async {
    final beds = await getAllBeds();
    beds.add(bed);
    await storage.saveJson(file, beds.map((e) => e.toJson()).toList());
  }

  Future<Bed?> findByBedNumber(String bedNumber) async {
    final beds = await getAllBeds();
    try {
      return beds.firstWhere((b) => b.bedNumber == bedNumber);
    } catch (e) {
      return null;
    }
}

  Future<void> updateBed(Bed bed) async {
    final beds = await getAllBeds();
    final index = beds.indexWhere((b) => b.bedNumber == bed.bedNumber);
    if (index != -1) {
      beds[index] = bed;
      await storage.saveJson(file, beds.map((e) => e.toJson()).toList());
    }
  }
}
