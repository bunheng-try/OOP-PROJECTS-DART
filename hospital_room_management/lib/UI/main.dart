import 'dart:io';
import '../Domain/models/patient.dart';
import '../Domain/services/allocation_service.dart';

Future<void> main() async {
  final service = AllocationService();

  print("Loading saved data...");
  await service.loadAll();
  print(" Data loaded successfully!");
  print('\n════════════════════════════════════════');
  print('    Hospital Room Management System');
  print('════════════════════════════════════════');
  while (true) {
    print('\n1) Register Patient');
    print('2) Show Available Beds');
    print('3) Allocate Bed');
    print('4) Show Active Allocations');
    print('5) Discharge Patient');
    print('6) View Patient History');
    print('7) Save All Changes');
    print('0) Exit');
    String formatDateTime(DateTime dt) {
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
             '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }

    stdout.write('> ');
    final input = stdin.readLineSync();

    if (input == '0') {
      print('Saving changes before exit...');
      await service.saveAll();
      print(' Changes saved. Goodbye!');
      break;
    }

    switch (input) {
      case '1':
        // Check Patient ID
        String id;
        while (true) {
          stdout.write('Patient ID: ');
          id = stdin.readLineSync()!;
          
          // Check for duplicate ID
          if (service.patients.any((p) => p.patientId == id)) {
            print(' Error: Patient ID already exists. Please use a different ID.');
            continue;
          }
          break;
        }
        
        stdout.write('Name: ');
        final name = stdin.readLineSync()!;
        
        // Validate age input
        int age;
        while (true) {
          try {
            stdout.write('Age: ');
            age = int.parse(stdin.readLineSync()!);
            if (age < 0 || age > 100) {
              print(' Error: Please enter a valid age (0-150)');
              continue;
            }
            break;
          } catch (e) {
            print(' Error: Please enter a valid number for age');
          }
        }
        
        stdout.write('Medical Condition: ');
        final condition = stdin.readLineSync()!;
        
        // Validate priority input
        String priority;
        while (true) {
          stdout.write('Priority (Low/Medium/High): ');
          priority = stdin.readLineSync()!.toLowerCase();
          
          if (['low', 'medium', 'high'].contains(priority)) {
            // Capitalize first letter for consistency
            priority = priority[0].toUpperCase() + priority.substring(1);
            break;
          } else {
            print(' Error: Please enter a valid priority (Low/Medium/High)');
          }
        }

        // Add patient to the service's patient list
        service.patients.add(Patient(
          patientId: id,
          name: name,
          age: age,
          medicalCondition: condition,
          priority: priority,
        ));
        await service.saveAll();
        print('\n Patient registered successfully!');
        print('Patient Details:');
        print('ID: $id');
        print('Name: $name');
        print('Age: $age');
        print('Medical Condition: $condition');
        print('Priority: $priority');
        break;

      case '2':
        print('\nAvailable Rooms:');
        for (var room in service.rooms) {
          final availableBedsInRoom = service.beds
              .where((b) => b.isAvailable && b.room.roomNumber == room.roomNumber)
              .toList();
          
          if (availableBedsInRoom.isNotEmpty) {
            print('\nRoom ${room.roomNumber} (${room.type}) - Floor ${room.floor}:');
            for (var bed in availableBedsInRoom) {
              print('  - Bed ${bed.bedNumber}');
            }
          }
        }
        break;

      case '3':
        // First show available rooms
        print('\nAvailable Rooms:');
        for (var room in service.rooms) {
          final availableBedsInRoom = service.beds
              .where((b) => b.isAvailable && b.room.roomNumber == room.roomNumber)
              .toList();
          
          if (availableBedsInRoom.isNotEmpty) {
            print('\nRoom ${room.roomNumber} (${room.type}) - Floor ${room.floor}:');
            for (var bed in availableBedsInRoom) {
              print('  - Bed ${bed.bedNumber}');
            }
          }
        }

        // Get patient
        stdout.write('\nPatient ID: ');
        final pid = stdin.readLineSync()!;
        final patient = service.patients
            .firstWhere(
                (p) => p.patientId == pid,
                orElse: () => throw Exception('Patient not found'));
        
        // Get room
        stdout.write('Enter Room Number: ');
        final roomNum = stdin.readLineSync()!;
        final room = service.rooms
            .firstWhere(
                (r) => r.roomNumber == roomNum,
                orElse: () => throw Exception('Room not found'));
        
        // Show available beds in selected room
        final availableBedsInRoom = service.beds
            .where((b) => b.isAvailable && b.room.roomNumber == room.roomNumber)
            .toList();
            
        if (availableBedsInRoom.isEmpty) {
          print(' No available beds in room $roomNum');
          break;
        }
        
        print('\nAvailable beds in Room $roomNum:');
        for (var bed in availableBedsInRoom) {
          print('  - Bed ${bed.bedNumber}');
        }
        
        // Get bed
        stdout.write('Enter Bed Number: ');
        final bedNum = stdin.readLineSync()!;
        
        try {
          final alloc = service.allocateBed(bedNumber: bedNum, patient: patient);
          print('\n Allocation successful:');
          print('Patient: ${alloc.patient.name}');
          print('Room: ${alloc.bed.room.roomNumber} (${alloc.bed.room.type})');
          print('Bed: ${alloc.bed.bedNumber}');
        } catch (e) {
          print(' Error: $e');
        }
        break;

      case '4':
        final active = service.allocations;
        if (active.isEmpty) print('No active allocations.');
        for (var a in active) print(a);
        break;

      case '5':
        stdout.write('Enter allocation ID: ');
        final id = stdin.readLineSync()!;
        try {
          service.discharge(id);
          print(' Discharged successfully!');
        } catch (e) {
          print(' Error: $e');
        }
        break;

      case '6':
        stdout.write('\nEnter Patient ID: ');
        final pid = stdin.readLineSync()!;
        
        try {
          final patient = service.patients
              .firstWhere((p) => p.patientId == pid,
                  orElse: () => throw Exception('Patient not found'));
          
          // Get all allocations for this patient
          final patientAllocations = service.allocations
              .where((a) => a.patient.patientId == pid)
              .toList();
          
          print('\n══════════════════════════════════════════');
          print('           PATIENT DETAILS');
          print('══════════════════════════════════════════');
          print('Name: ${patient.name}');
          print('ID: ${patient.patientId}');
          print('Age: ${patient.age}');
          print('Medical Condition: ${patient.medicalCondition}');
          print('Priority Level: ${patient.priority}');
          
          // Current Status
          final currentAllocation = patientAllocations
              .where((a) => a.status == 'Active')
              .firstOrNull;
          
          print('\n══════════════════════════════════════════');
          print('           CURRENT STATUS');
          print('══════════════════════════════════════════');
          if (currentAllocation != null) {
            print('Currently Admitted');
            print('Room: ${currentAllocation.bed.room.roomNumber} (${currentAllocation.bed.room.type})');
            print('Floor: ${currentAllocation.bed.room.floor}');
            print('Bed: ${currentAllocation.bed.bedNumber}');
            print('Duration: ${currentAllocation.getDuration()}');
          } else {
            print('Not Currently Admitted');
          }
          
          // Admission History
          final completedAllocations = patientAllocations
              .where((a) => a.status == 'Completed')
              .toList();
          
          print('\n══════════════════════════════════════════');
          print('         ADMISSION HISTORY');
          print('══════════════════════════════════════════');
          
          if (completedAllocations.isEmpty && currentAllocation == null) {
            print('No admission history found');
          } else {
            // Sort by start date, most recent first
            patientAllocations.sort((a, b) => b.startDate.compareTo(a.startDate));
            
            int count = 1;
            for (var allocation in patientAllocations) {
              print('\nAdmission #${count++}:');
              print('Room: ${allocation.bed.room.roomNumber} (${allocation.bed.room.type})');
              print('Floor: ${allocation.bed.room.floor}');
              print('Bed: ${allocation.bed.bedNumber}');
              print('Started: ${formatDateTime(allocation.startDate)}');
              if (allocation.endDate != null) {
                print('Ended: ${formatDateTime(allocation.endDate!)}');
              }
              print('Duration: ${allocation.getDuration()}');
              print('Status: ${allocation.status}');
              print('----------------------------------------');
            }
          }
          
          // Statistics
          print('\n══════════════════════════════════════════');
          print('            STATISTICS');
          print('══════════════════════════════════════════');
          print('Total Admissions: ${patientAllocations.length}');
          print('ICU Admissions: ${patientAllocations.where((a) => a.bed.room.type == 'ICU').length}');
          print('General Ward Admissions: ${patientAllocations.where((a) => a.bed.room.type == 'General').length}');
          
        } catch (e) {
          print('⚠️ Error: $e');
        }
        break;
        
      case '7':
        try {
          await service.saveAll();
          print('✅ All changes saved successfully!');
        } catch (e) {
          print('⚠️ Error saving data: $e');
        }
        break;

      default:
        print('Invalid choice.');
    }
  }
}


// the console I let ai to help me to write the console for me