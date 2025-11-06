class Patient {
  final String patientId;
  final String name;
  final int age;
  final String medicalCondition;
  final String priority; // Low, Medium, High

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
        'priority': priority,
      };

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        patientId: json['patientId'],
        name: json['name'],
        age: json['age'],
        medicalCondition: json['medicalCondition'],
        priority: json['priority'],
      );

  @override
  String toString() => 'Patient($name - $priority)';
}
