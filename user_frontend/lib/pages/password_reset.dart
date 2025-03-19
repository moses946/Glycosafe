import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:glycosafe_v1/components/endpoints.dart";
import "package:glycosafe_v1/components/errorarlert.dart";
import "package:glycosafe_v1/components/token_service.dart";
import "package:google_fonts/google_fonts.dart";
import "package:http/http.dart" as http;
import "package:jwt_decode/jwt_decode.dart";

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordResetScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  void _toggleCurrentPasswordVisibility() {
    setState(() {
      _obscureCurrentPassword = !_obscureCurrentPassword;
    });
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _obscureNewPassword = !_obscureNewPassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      String currentPassword = _currentPasswordController.text;
      String newPassword = _newPasswordController.text;

      if (currentPassword == newPassword) {
        ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
            content:
                'Current password and new password should not be the same'));
        return;
      }
      try {
        EasyLoading.show();
        // Print the passwords to the console
        var url = Endpoints().change_password;
        var request = http.Request("POST", Uri.parse(url));

        var tokens = await TokenService().getTokens();
        var accessToken = Jwt.parseJwt(tokens[0]!);

        request.headers["Content-Type"] = 'application/json; charset=UTF-8';
        // request.headers["Authorization"] = 'Bearer $accessToken';
        request.body = jsonEncode({
          'current_password': currentPassword,
          "new_password": newPassword,
          'user_id': accessToken["user_id"].toString()
        });

        var response = await request.send();

        if (response.statusCode >= 200 && response.statusCode < 300) {
          EasyLoading.dismiss();
          ScaffoldMessenger.of(context).showSnackBar(
              ErrorSnackBar(content: "Password changed successfully👍"));
          Navigator.of(context).pop();
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
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
        ),
        title: Text("Change Password",
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.7),
            )),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, left: 25, right: 25, bottom: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Your password must be at least 6 characters and should include a combination of numbers, letters and special characters (!\$@%).',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white)),
                    ),
                    const SizedBox(height: 35),
                    TextFormField(
                      style: TextStyle(color: Colors.white.withOpacity(0.6)),
                      controller: _currentPasswordController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Current password',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.6)),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your current password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _newPasswordController,
                      style: TextStyle(color: Colors.white.withOpacity(0.6)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'New password',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.6)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            color: Colors.white.withOpacity(0.6),
                            _obscureNewPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: _toggleNewPasswordVisibility,
                        ),
                      ),
                      obscureText: _obscureNewPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a new password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      style: TextStyle(color: Colors.white.withOpacity(0.6)),
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Retype new password',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.6)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            color: Colors.white.withOpacity(0.6),
                            _obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: _toggleConfirmPasswordVisibility,
                        ),
                      ),
                      obscureText: _obscureConfirmPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please retype your new password';
                        }
                        if (value != _newPasswordController.text) {
                          return 'New password and confirmation password do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(color: Colors.white),
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _changePassword,
                          child: Text('Change Password',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
