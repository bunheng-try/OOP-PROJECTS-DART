import '../domain/models/bed_allocation.dart';
import 'json_storage.dart';

class AllocationRepository {
  final storage = JsonStorage();
  final String file = 'data/allocations.json';

  Future<List<BedAllocation>> getAllAllocations() async {
    final data = await storage.readJson(file);
    return data.map((e) => BedAllocation.fromJson(e)).toList();
  }

  Future<void> addAllocation(BedAllocation alloc) async {
    final list = await getAllAllocations();
    list.add(alloc);
    await storage.saveJson(file, list.map((e) => e.toJson()).toList());
  }
}
