import 'enums.dart';

class Patient {
  final String patientId;
  final String name;
  final int age;
  final String medicalCondition;
  final PatientPriority priority;

  Patient({
    required this.patientId,
    required this.name,
    required this.age,
    required this.medicalCondition,
    required this.priority,
  });

  Map<String, dynamic> toJson() => {
        'patientId': patientId,
        'name': name,
        'age': age,
        'medicalCondition': medicalCondition,
        'priority': priority.name,
      };

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        patientId: json['patientId'],
        name: json['name'],
        age: json['age'],
        medicalCondition: json['medicalCondition'],
        priority: PatientPriority.values
            .firstWhere((e) => e.name == json['priority']),
      );
}
