import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:glycosafe_v1/providers/appstate_provider.dart';
import 'package:glycosafe_v1/components/endpoints.dart';
import 'package:glycosafe_v1/components/errorarlert.dart';
import 'package:glycosafe_v1/components/profile_picture.dart';
import 'package:glycosafe_v1/components/token_service.dart';
import 'package:glycosafe_v1/pages/db.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:intl/intl.dart";
import "package:image_picker/image_picker.dart";
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class EditPersonalInfo extends StatefulWidget {
  const EditPersonalInfo({super.key});

  @override
  State<EditPersonalInfo> createState() => _EditPersonalInfoState();
}

class _EditPersonalInfoState extends State<EditPersonalInfo> {
  bool _isEditing = false;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    var appState = context.read<MyAppState>();
    _firstNameController.text = appState.firstName;
    _lastNameController.text = appState.lastName;
    _phoneNumberController.text = appState.phoneNumber;
    _dobController.text = appState.birthday;
    _emailController.text = appState.email;
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  String? _validateChange(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field should not be empty';
    }
    return null;
  }

  Future<void> _imagePicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _saveInfo() async {
    try {
      _toggleEdit();

      EasyLoading.show();
      // Print the passwords to the console
      var url = Endpoints().update_personal_info;
      var request = http.Request("PUT", Uri.parse(url));

      var tokens = await TokenService().getTokens();
      var accessToken = Jwt.parseJwt(tokens[0]!);
      var databaseHelper = DatabaseHelper();
      var appState = Provider.of<MyAppState>(context, listen: false);

      request.headers["Content-Type"] = 'application/json; charset=UTF-8';
      var user = {
        "user_id": accessToken['user_id'],
        "first_name": _firstNameController.text,
        "last_name": _lastNameController.text,
        "phone_number": _phoneNumberController.text,
        "date_of_birth": _dobController.text,
      };
      request.body = jsonEncode(user);
      var response = await request.send();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        databaseHelper.updateProfile(user["user_id"], user["first_name"],
            user["last_name"], user["date_of_birth"], user["phone_number"]);
        appState.setDetails();
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
            ErrorSnackBar(content: "Personal details changed successfully👍"));
        Navigator.of(context).pop();
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context)
            .showSnackBar(ErrorSnackBar(content: "Error from server!"));
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

  void _showDatePicker(BuildContext context) {
    DatePicker.showDatePicker(context,
        dateFormat: "dd-MMMM-yyyy",
        minDateTime: DateTime(1900),
        maxDateTime: DateTime.now(),
        initialDateTime: DateTime(2006), onConfirm: (datetime, list) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(datetime);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = (MediaQuery.of(context).size.width - 90) / 2;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Personal Information",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white.withOpacity(0.7),
            )),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: _profileImage != null
                        ? Image.file(
                            _profileImage!,
                            fit: BoxFit.cover,
                          )
                        : ProfilePicture(firstName: _firstNameController.text),
                  ),
                ),
                // IconButton(
                //   onPressed: () {
                //     _imagePicker();
                //   },
                //   icon: const Icon(
                //     Icons.edit_outlined,
                //     size: 20,
                //     color: Colors.white,
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 45),
            Row(
              children: [
                SizedBox(
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "First Name",
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w500),
                      ),
                      TextFormField(
                          controller: _firstNameController,
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.6)),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            hintText: _firstNameController.text,
                            hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                          enabled: _isEditing,
                          validator: _validateChange),
                    ],
                  ),
                ),
                const SizedBox(width: 30),
                SizedBox(
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Last Name",
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w500),
                      ),
                      TextFormField(
                        controller: _lastNameController,
                        style: TextStyle(color: Colors.white.withOpacity(0.6)),
                        decoration: InputDecoration(
                            filled: true,
                            hintText: _lastNameController.text,
                            fillColor: Colors.white.withOpacity(0.1)),
                        enabled: _isEditing,
                        validator: _validateChange,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              "Email Address",
              style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w500),
            ),
            TextField(
              controller: _emailController,
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
              decoration: InputDecoration(
                  hintText: _emailController.text,
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1)),
              enabled: false,
            ),
            const SizedBox(height: 15),
            Text(
              "Phone Number",
              style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w500),
            ),
            TextFormField(
              validator: _validateChange,
              controller: _phoneNumberController,
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
              decoration: InputDecoration(
                  hintText: _phoneNumberController.text,
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1)),
              enabled: _isEditing,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10)
              ],
            ),
            const SizedBox(height: 15),
            Text(
              "Date of Birth",
              style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w500),
            ),
            TextField(
              controller: _dobController,
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
              decoration: InputDecoration(
                  hintText: _dobController.text,
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1)),
              enabled: _isEditing,
              onTap: _isEditing
                  ? () {
                      _showDatePicker(context);
                    }
                  : () {},
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                // onPrimary: Colors.white,
                minimumSize: const Size(350, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _isEditing ? _saveInfo : _toggleEdit,
              child: Text(
                _isEditing ? "Save Details" : "Edit Details",
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
