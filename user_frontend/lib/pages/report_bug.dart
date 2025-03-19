// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:glycosafe_v1/providers/appstate_provider.dart';
import 'package:glycosafe_v1/components/endpoints.dart';
import 'package:glycosafe_v1/components/errorarlert.dart';
import 'package:glycosafe_v1/components/token_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ReportBug extends StatefulWidget {
  const ReportBug({super.key});

  @override
  _BugReportPageState createState() => _BugReportPageState();
}

class _BugReportPageState extends State<ReportBug> {
  final _bugController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var url = Endpoints().report_bug;

  void _submitBugReport() async {
    try {
      EasyLoading.show();
      if (_formKey.currentState!.validate()) {
        var userId = Provider.of<MyAppState>(context).userId;
        // var userId = context.watch<MyAppState>().userId;
        var tokens = await TokenService().getTokens();
        var accessToken = tokens[0];
        var request = http.Request("POST", Uri.parse(url));
        // request.headers["Authorization"] = "Bearer $accessToken";

        request.body =
            jsonEncode({"user_id": userId, "issue": _bugController.text});

        var response = await request.send();

        if (response.statusCode >= 200 || response.statusCode < 300) {
          _bugController.clear();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          ErrorSnackBar(content: 'Bug report submitted successfully!'),
        );
      }
    } on Exception {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context)
          .showSnackBar(ErrorSnackBar(content: "Error sending bug"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
        title: Text(
          "Report a bug",
          style: GoogleFonts.inter(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.orange),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Icon(
                      Icons.bug_report,
                      size: 100,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "We are sad to hear you've encountered a bug. Please share the issue and the dev team will be happy to fix it 😊",
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 138, 136, 136)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _bugController,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Describe the bug here...',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 138, 136, 136)),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please describe the bug';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          _submitBugReport();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          // onPrimary: Colors.white,
                          minimumSize: const Size(200, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bugController.dispose();
    super.dispose();
  }
}
