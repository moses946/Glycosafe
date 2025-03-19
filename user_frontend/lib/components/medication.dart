import 'package:flutter/material.dart';

class Medication {
  String name;
  String dosage;
  int frequency;
  TimeOfDay startTime;
  String icon;
  String medication_id;
  String instructions;
  String frequency_unit;

  Medication({
    required this.medication_id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.startTime,
    required this.icon,
    required this.instructions,
    required this.frequency_unit,
  });
}
