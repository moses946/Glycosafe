import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glycosafe_v1/components/medication.dart';
import 'package:glycosafe_v1/providers/medications_provider.dart';
import 'package:glycosafe_v1/pages/add_medication.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class Medications extends StatelessWidget {
  const Medications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/home2");
              },
              icon:
                  const Icon(Icons.arrow_back, color: Colors.white, size: 22)),
          title: GradientText(
            'Medications',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
            gradientType: GradientType.linear,
            gradientDirection: GradientDirection.ttb,
            radius: .4,
            colors: const [
              Colors.orange,
              Colors.orange,
              Colors.white,
            ],
          ),
          elevation: 0,
          centerTitle: true,
          scrolledUnderElevation: 0.0,
          backgroundColor: Colors.transparent),
      backgroundColor: Colors.black,
      body: const Column(children: [
        // TopContainer(),
        SizedBox(
          height: 20,
        ),
        Flexible(child: BottomContainer()),
      ]),
      floatingActionButton: InkResponse(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddMedicationPage(),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(right: 10, bottom: 15),
          child: const Icon(
            Icons.add_circle,
            size: 50,
            color: Colors.orange,
          ),
        ),
      ),
    );
  }
}

class BottomContainer extends StatelessWidget {
  const BottomContainer({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var medicationsProvider = Provider.of<MedicationProvider>(context);
    var medications = medicationsProvider.medications;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: medications.isEmpty
          ? Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/log-medication.svg',
                      width: 150,
                      height: 250,
                    ),
                    const SizedBox(height: 60),
                    Text(
                      "Keep Track",
                      style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Of all medication you take",
                      style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withAlpha(160)),
                      textAlign: TextAlign.center,
                    ),
                  ]),
            )
          : ListView.builder(
              itemCount: medications.length,
              itemBuilder: (context, index) {
                final medication = medications[index];
                String iconData;
                switch (medication.icon) {
                  case 'injection':
                    iconData = "assets/syringe-solid.svg";
                    break;
                  case 'tablet':
                    iconData = "assets/tablets-solid.svg";
                    break;
                  case 'liquid':
                    iconData = "assets/liquid-medication-solid.svg";
                    break;
                  default:
                    iconData = "assets/capsules-solid.svg";
                }
                String frequency;
                switch (medication.frequency) {
                  case 1:
                    frequency = "Once";
                  case 2:
                    frequency = "Twice";
                  default:
                    frequency = "${medication.frequency} times";
                }
                return Container(
                  width: width * 0.7,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.white.withOpacity(0.1),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(42, 14, 14, 14),
                            blurRadius: 3,
                            offset: Offset(0, 2)),
                      ]),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: SvgPicture.asset(
                      iconData,
                      color: Colors.orange,
                      width: 30,
                      height: 30,
                    ),
                    title: Text(
                      medication.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                    subtitle: Text(
                      'Dosage: ${medication.dosage}\nFrequency: $frequency daily',
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () =>
                        _showMedicationDetails(context, medication, index),
                  ),
                );
              },
            ),
    );
  }

  void _showMedicationDetails(
      BuildContext context, Medication medication, int index) {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 42, 42, 42),
      context: context,
      builder: (context) {
        String iconData;
        switch (medication.icon) {
          case 'injection':
            iconData = "assets/syringe-solid.svg";
            break;
          case 'tablet':
            iconData = "assets/tablets-solid.svg";
            break;
          case 'liquid':
            iconData = "assets/liquid-medication-solid.svg";
            break;
          default:
            iconData = "assets/capsules-solid.svg";
        }
        String frequency;
        switch (medication.frequency) {
          case 1:
            frequency = "Once";
          case 2:
            frequency = "Twice";
          default:
            frequency = "${medication.frequency} times";
        }
        return Container(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(5),
                leading: SvgPicture.asset(
                  iconData,
                  color: Colors.orange,
                  width: 30,
                  height: 30,
                ),
                title: Text(
                  medication.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                subtitle: Text(
                  'Dosage: ${medication.dosage} \nFrequency: $frequency daily \nFirst Dose: ${medication.startTime.format(context)}',
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Provider.of<MedicationProvider>(context, listen: false)
                        .deleteMedication(medication.medication_id);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[800],
                    // onPrimary: Colors.white,
                    minimumSize: const Size(100, 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Delete Medication',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        );
      },
    );
  }
}
