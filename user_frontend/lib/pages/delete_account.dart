import 'dart:convert';
import 'package:glycosafe_v1/providers/appstate_provider.dart';
import 'package:glycosafe_v1/components/token_service.dart';
import 'package:glycosafe_v1/pages/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:glycosafe_v1/components/endpoints.dart';
import 'package:glycosafe_v1/components/errorarlert.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureCurrentPassword = true;

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  void _toggleCurrentPasswordVisibility() {
    setState(() {
      _obscureCurrentPassword = !_obscureCurrentPassword;
    });
  }

  Future _sendPassword(BuildContext context) async {
    try {
      var appState = Provider.of<MyAppState>(context, listen: false);
      EasyLoading.show();
      var password = _passwordController.text;
      var tokens = await TokenService().getTokens();
      var accessToken = Jwt.parseJwt(tokens[0]!);
      final request =
          http.Request("post", Uri.parse(Endpoints().delete_account));

      request.headers["Content-Type"] = 'application/json; charset=UTF-8';
      request.body = jsonEncode(
          {'password': password, 'user_id': accessToken["user_id"].toString()});

      var response = await request.send();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        TokenService().deleteToken("access_token");
        TokenService().deleteToken("refresh_token");
        appState.logout(2);
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
            ErrorSnackBar(content: "Account deleted successfully"));
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => const Login()));
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context)
            .showSnackBar(ErrorSnackBar(content: "Incorrect Password"));
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
        title: Text("Delete Account",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 26,
            )),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25),
          children: [
            Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.orange, width: 3)),
                margin: const EdgeInsets.only(top: 70, bottom: 30),
                child: const Icon(
                  Icons.person_remove_alt_1_outlined,
                  color: Colors.orange,
                  size: 50,
                )),
            Text(
              "We are sad to see you leave😭",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              child: Text(
                "Enter your password to confirm this action.",
                style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            const Text(
              "*Note: This action is final and cannot be undone!",
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                style: TextStyle(color: Colors.white.withOpacity(0.6)),
                controller: _passwordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Current password',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      color: Colors.white.withOpacity(0.6),
                      _obscureCurrentPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: _toggleCurrentPasswordVisibility,
                  ),
                ),
                obscureText: _obscureCurrentPassword,
                validator: _validatePassword),
            const SizedBox(
              height: 40,
            ),
            Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    _sendPassword(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    // onPrimary: Colors.white,
                    minimumSize: const Size(350, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Delete Account",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  )),
            ),
            const Spacer(
              flex: 6,
            ),
          ]),
    );
  }
}
