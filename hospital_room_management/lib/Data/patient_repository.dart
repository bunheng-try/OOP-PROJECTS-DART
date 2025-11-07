import '../domain/models/patient.dart';
import 'json_storage.dart';

class PatientRepository {
  final storage = JsonStorage();
  final String file = 'data/patients.json';

  Future<List<Patient>> getAllPatients() async {
    final data = await storage.readJson(file);
    return data.map((e) => Patient.fromJson(e)).toList();
  }

  Future<void> addPatient(Patient patient) async {
    final patients = await getAllPatients();
    patients.add(patient);
    await storage.saveJson(file, patients.map((e) => e.toJson()).toList());
  }

  Future<Patient?> findById(String id) async {
    final patients = await getAllPatients();
    return patients.firstWhere((p) => p.patientId == id, orElse: () => null);
  }
}
