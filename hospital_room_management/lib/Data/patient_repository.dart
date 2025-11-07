import '../domain/models/patient.dart';
import 'json_storage.dart';
//AI generated code for PatientRepository using JsonStorage
class PatientRepository {
  final JsonStorage storage = JsonStorage();
  final String file = 'data/patients.json';

  Future<List<Patient>> getAllPatients() async {
    try {
      final data = await storage.readJson(file);
      if (data is List) {
        return data.map((e) => Patient.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print("Error reading patients: $e");
      return [];
    }
  }

  Future<void> addPatient(Patient patient) async {
    try {
      final patients = await getAllPatients();
      
      // Check if patient already exists and remove if so (to update)
      patients.removeWhere((p) => p.patientId == patient.patientId);
      
      // Add the new patient
      patients.add(patient);
      
      // Save to JSON file
      await storage.saveJson(file, patients.map((e) => e.toJson()).toList());
      print("Patient ${patient.patientId} saved to JSON successfully.");
    } catch (e) {
      print("Error saving patient: $e");
      rethrow;
    }
  }

  Future<Patient?> findById(String id) async {
    final patients = await getAllPatients();
    try {
      return patients.firstWhere((p) => p.patientId == id);
    } catch (e) {
      return null;
    }
  }
}