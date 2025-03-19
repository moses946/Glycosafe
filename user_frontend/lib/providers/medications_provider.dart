import 'package:flutter/material.dart';
import 'package:glycosafe_v1/pages/db.dart';
import '../components/local_notifications.dart';
import '../components/medication.dart';

class MedicationProvider with ChangeNotifier {
  var dbHelper = DatabaseHelper();
  final List<Medication> _medications = [];

  MedicationProvider() {
    initMedications();
  }
  List<Medication> get medications => _medications;

  void initMedications() async {
    List meds = await dbHelper.getMedications();
    for (Map med in meds) {
      var newMed = medFromDB(med);
      for (int i = 0; i < newMed.frequency; i++) {
        final notificationTime = newMed.startTime.replacing(
          hour: (newMed.startTime.hour + i * (24 ~/ newMed.frequency)) % 24,
        );
        LocalNotifications.showScheduleNotification(
          title: 'Time to take your medication',
          body: 'It\'s time to take ${newMed.name} (${newMed.dosage})',
          payload: 'medication_${newMed.name}',
          scheduledDate: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            notificationTime.hour,
            notificationTime.minute,
          ),
          id: UniqueKey().hashCode,
        );
      }
      _medications.add(newMed);
    }
    notifyListeners();
  }

  TimeOfDay stringToTimeOfDay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  Medication medFromDB(Map med) {
    var newMed = Medication(
        instructions: med["instructions"],
        frequency_unit: med["frequecy_unit"],
        medication_id: med["medication_id"],
        name: med["medication_name"],
        dosage: med["dosage"],
        frequency: med["frequency"],
        icon: med["icon"],
        startTime: stringToTimeOfDay(med["start_time"]));
    return newMed;
  }

  void addMedication(Medication medication) {
    _medications.add(medication);
    dbHelper.addMedication(
        instruction: medication.instructions,
        frequency_unit: medication.frequency_unit,
        medication_id: medication.medication_id,
        dosage: medication.dosage,
        start_time: timeOfDayToString(medication.startTime),
        medication_name: medication.name,
        frequency: medication.frequency,
        icon: medication.icon);
    notifyListeners();
  }

  void deleteMedication(String medId) {
    _medications.removeWhere((medication) => medication.medication_id == medId);
    dbHelper.deleteMedication(medId);
    notifyListeners();
  }

  String timeOfDayToString(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
