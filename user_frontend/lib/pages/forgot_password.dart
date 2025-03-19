import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:glycosafe_v1/components/endpoints.dart';
import 'package:glycosafe_v1/components/errorarlert.dart';
import 'package:glycosafe_v1/pages/confirmation.dart';

class ForgotPassword extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  ForgotPassword({super.key});

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  Future _sendCode(BuildContext context) async {
    try {
      EasyLoading.show();
      if (_formKey.currentState!.validate()) {
        var email = _emailController.text;
        var user = {"email": email};
        var request = http.Request("POST",
            Uri.parse(Endpoints().forgot_password)); //sendcode endpoint needed
        request.headers["Content-Type"] = "application/json";
        request.body = jsonEncode({"email": email});

        var response = await request.send();

        if (response.statusCode == 200) {
          // ignore: use_build_context_synchronously
          EasyLoading.dismiss();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => Confirmation(
                  user: user,
                  lastRoute: "/Login",
                  url: Endpoints().confirm_reset)));
        } else if (response.statusCode >= 400 && response.statusCode < 500) {
          EasyLoading.dismiss();
          ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
            content: "Email not linked to an account!",
          ));
        }
      } else {
        EasyLoading.dismiss();
      }
    } on http.ClientException {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
          content: "Check your internet connection and try again."));
    } catch (e) {
      EasyLoading.dismiss();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
          content: "Server Error! Try again after a few minutes."));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3)),
                margin: const EdgeInsets.only(top: 50, bottom: 20),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  color: Colors.white,
                  size: 50,
                )),
            Text(
              "Having trouble logging in?",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              child: const Text(
                "Enter the email associated with your account and we'll send you a code to help reset your password.",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  labelText: 'Email',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                validator: _validateEmail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () {
                  _sendCode(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  // onPrimary: Colors.white,
                  minimumSize: const Size(280, 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Get Code",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                )),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed("/login");
                },
                child: const Text(
                  "Back to login",
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
