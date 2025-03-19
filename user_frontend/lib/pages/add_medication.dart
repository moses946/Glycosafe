import 'dart:convert';
import 'dart:math';
import 'package:glycosafe_v1/components/endpoints.dart';
import 'package:glycosafe_v1/components/token_service.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glycosafe_v1/components/errorarlert.dart';
import 'package:glycosafe_v1/components/local_notifications.dart';
import 'package:glycosafe_v1/components/medication.dart';
import 'package:glycosafe_v1/providers/medications_provider.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
// import 'package:vector_math/vector_math_64.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AddMedicationPage extends StatefulWidget {
  const AddMedicationPage({super.key});

  @override
  _AddMedicationPageState createState() => _AddMedicationPageState();
}

class _AddMedicationPageState extends State<AddMedicationPage> {
  final _formKey = GlobalKey<FormState>();
  String _medicationName = '';
  String _dosage = '';
  int _frequency = 1;
  TimeOfDay _startTime = TimeOfDay.now();
  String _icon = 'pill';
  String _frequency_unit = 'Daily';
  String _instruction = '';

  final List<String> _frequencyOptions = ['1', '2', '3', '4', '5'];
  final List<String> _icons = ['Pill', 'Injection', 'Tablet', 'Liquid'];
  String _medId(String MedName) {
    final random = Random();
    final int1 =
        random.nextInt(100); // Generates a random integer between 0 and 99
    final int2 = random.nextInt(100);
    final int3 = random.nextInt(100);

    return '$MedName$int1$int2$int3';
  }

  void _postMeds() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        EasyLoading.show(status: "Adding medication");

        final medication = Medication(
          instructions: _instruction,
          frequency_unit: _frequency_unit,
          medication_id: _medId(_medicationName),
          name: _medicationName,
          dosage: _dosage,
          frequency: _frequency,
          startTime: _startTime,
          icon: _icon,
        );
        var medicationProvider =
            Provider.of<MedicationProvider>(context, listen: false);
        var tokens = await TokenService().getTokens();
        var accessToken = tokens[0];
        var userId = Jwt.parseJwt(accessToken!)["user_id"].toString();

        var url = Endpoints().add_medication;
        var request = http.Request("POST", Uri.parse(url));
        // request.headers["Authorization"] = "Bearer $accessToken";
        var meds = {
          "user": userId,
          "drug_name": medication.name,
          "frequency": medication.frequency.toString(),
          "frequency_unit": medication.frequency_unit[0],
          "icon_name": medication.icon,
          "start_time":
              medicationProvider.timeOfDayToString(medication.startTime),
          "instructions": medication.instructions,
          "dosage": medication.dosage,
          "medication_id": medication.medication_id,
        };
        request.body = jsonEncode(meds);

        var response = await request.send();
        if (response.statusCode >= 200 && response.statusCode < 300) {
          medicationProvider.addMedication(medication);
          final now = DateTime.now();
          for (int i = 0; i < _frequency; i++) {
            DateTime scheduledDate;

            if (_frequency_unit == 'Daily') {
              // Daily frequency
              final notificationTime = _startTime.replacing(
                hour: (_startTime.hour + i * (24 ~/ _frequency)) % 24,
              );
              scheduledDate = DateTime(
                now.year,
                now.month,
                now.day,
                notificationTime.hour,
                notificationTime.minute,
              );
            } else if (_frequency_unit == 'Weekly') {
              // Weekly frequency
              scheduledDate = DateTime(
                now.year,
                now.month,
                now.day + (i * (7 ~/ _frequency)),
                _startTime.hour,
                _startTime.minute,
              );
            } else {
              throw ArgumentError('Invalid frequency unit: $_frequency_unit');
            }

            if (scheduledDate.isBefore(now)) {
              // Adjust the scheduled date to the next period if it's in the past
              scheduledDate = scheduledDate
                  .add(Duration(days: _frequency_unit == 'D' ? 1 : 7));
            }

            LocalNotifications.showScheduleNotification(
              title: 'Time to take your medication',
              body:
                  'It\'s time to take $_medicationName ($_dosage)\n$_instruction',
              payload: 'medication_$_medicationName',
              scheduledDate: scheduledDate,
              id: UniqueKey().hashCode,
            );
          }

          Navigator.pop(context);
          EasyLoading.dismiss();
        } else {
          EasyLoading.dismiss();
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
            content: "${response.statusCode}: Error from the server",
          ));
        }
      }
    } on http.ClientException {
      EasyLoading.dismiss();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
          content: "Check your internet connection and try again."));
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          ErrorSnackBar(content: "Unable to add medication, try again later."));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("/medications");
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20)),
        title: const Text(
          'Add New Medication',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    labelText: 'Medication Name',
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter medication name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _medicationName = value!;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    labelText: 'Dosage',
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    hintText: 'e.g., 100mg/ 2pills/ 100ml',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter dosage';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _dosage = value!;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                DropdownButtonFormField(
                  dropdownColor: const Color.fromARGB(255, 33, 32, 32),
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    labelText: 'Frequency',
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  value: _frequencyOptions[0],
                  items: _frequencyOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text('$value times'),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _frequency = int.parse(newValue!);
                    });
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                DropdownButtonFormField(
                  dropdownColor: const Color.fromARGB(255, 33, 32, 32),
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    labelText: 'Frequency Unit',
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  value: "Daily",
                  items: ["Daily", "Weekly"].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _frequency_unit = newValue!;
                    });
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.fromBorderSide(BorderSide(
                        width: 1.1,
                        style: BorderStyle.solid,
                        color: const Color.fromARGB(255, 142, 105, 51)
                            .withOpacity(0.3))),
                  ),
                  child: ListTile(
                    title: Text(
                      'Start Time',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                    trailing: Text(
                      _startTime.format(context),
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.w500,
                          fontSize: 13),
                    ),
                    onTap: () async {
                      TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: _startTime,
                          initialEntryMode: TimePickerEntryMode.input);
                      if (picked != null && picked != _startTime) {
                        setState(() {
                          _startTime = picked;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    labelText: 'Instructions',
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  onSaved: (value) {
                    _instruction = value ?? "";
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _icons.map((icon) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _icon = icon;
                        });
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            icon == "Pill"
                                ? "assets/capsules-solid.svg"
                                : icon == "Injection"
                                    ? "assets/syringe-solid.svg"
                                    : icon == "Tablet"
                                        ? "assets/tablets-solid.svg"
                                        : "assets/liquid-medication-solid.svg",
                            color: _icon == icon
                                ? Colors.orange
                                : Colors.green[400]!.withAlpha(100),
                            width: 40,
                            height: 40,
                          ),
                          Text(
                            icon,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    // onPrimary: Colors.white,
                    minimumSize: const Size(280, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    _postMeds();
                  },
                  child: const Text(
                    'Save Medication',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
