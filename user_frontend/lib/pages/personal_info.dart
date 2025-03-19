// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:glycosafe_v1/components/errorarlert.dart';
// import 'package:glycosafe_v1/components/logo.dart';
// import 'package:glycosafe_v1/main.dart';
// import 'package:provider/provider.dart';

// class PersonalInfo extends StatefulWidget {
//   @override
//   State<PersonalInfo> createState() => _PersonalInfoState();
// }

// class _PersonalInfoState extends State<PersonalInfo> {
//   final _formKey = GlobalKey<FormState>();
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _phoneNumberController = TextEditingController();
//   final _dateOfBirthController = TextEditingController();
//   String? _selectedGender;
//   String? _diabeticStatus;
//   String? _diabetesType;
//   final _glycemicLoadController = TextEditingController();
//   bool _showAdditionalFields = false;

//   @override
//   void dispose() {
//     // Dispose controllers
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _phoneNumberController.dispose();
//     _dateOfBirthController.dispose();
//     _glycemicLoadController.dispose();

//     super.dispose();
//   }

//   String? _validateNotEmpty(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'This field cannot be empty';
//     }
//     return null;
//   }

//   String? _validatePhoneNumber(String? value) {
//     if (value!.length != 10)
//       return "Enter a valid phone number";
//     else
//       return null;
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       if (_diabeticStatus == null || _diabeticStatus!.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           ErrorSnackBar(content: 'Please select a diabetic status'),
//         );
//         return;
//       }
//       // Process data from Personal Info Form
//       String firstName = _firstNameController.text;
//       String lastName = _lastNameController.text;
//       String phoneNumber = _phoneNumberController.text;
//       String dateOfBirth = _dateOfBirthController.text;
//       String glycemicLoad = _glycemicLoadController.text;
//       String diabeticStatus = _diabeticStatus ?? "";
//       String diabetesType = _diabetesType ?? "";
//       String selectedGender = _selectedGender ?? "";

//       // Print data for demonstration (You can handle this data as needed)
//       print('First Name: $firstName');
//       print('Last Name: $lastName');
//       print('Phone Number: $phoneNumber');
//       print('Date of Birth: $dateOfBirth');
//       print('Gender: $selectedGender');
//       print('Diabetic Status: $diabeticStatus');
//       print('Diabetes Type: $diabetesType');
//       print('Glycemic Load Threshold: $glycemicLoad');

//       // Show a success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         ErrorSnackBar(content: 'Form submitted successfully!'),
//       );
//       Navigator.of(context).pushReplacementNamed("/camera");
//     } else {
//       print('Form is invalid');
//     }
//   }

//   void _handleDiabeticStatusChange(String? value) {
//     setState(() {
//       _diabeticStatus = value!;
//       _showAdditionalFields = _diabeticStatus == 'Yes';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     return Scaffold(
//       // appBar: AppBar(title: const Text("Personal info")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               const Logo(),
//               const Text(
//                 "Personal Information",
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w800,
//                     fontSize: 20),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: _firstNameController,
//                       textCapitalization: TextCapitalization.words,
//                       decoration: const InputDecoration(
//                         labelText: 'First name',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                         ),
//                         prefixIcon: Icon(Icons.person),
//                       ),
//                       validator: _validateNotEmpty,
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: TextFormField(
//                       textCapitalization: TextCapitalization.words,
//                       controller: _lastNameController,
//                       decoration: const InputDecoration(
//                         labelText: 'Last name',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                         ),
//                         prefixIcon: Icon(Icons.person),
//                       ),
//                       validator: _validateNotEmpty,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                   controller: _phoneNumberController,
//                   keyboardType: const TextInputType.numberWithOptions(),
//                   inputFormatters: <TextInputFormatter>[
//                     LengthLimitingTextInputFormatter(10),
//                     FilteringTextInputFormatter.digitsOnly,
//                     FilteringTextInputFormatter.singleLineFormatter
//                   ],
//                   decoration: const InputDecoration(
//                     labelText: 'Phone Number',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                     ),
//                     prefixIcon: Icon(Icons.phone),
//                   ),
//                   validator: _validatePhoneNumber),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: _dateOfBirthController,
//                       readOnly: true, // Make the text field read-only
//                       decoration: const InputDecoration(
//                         labelText: 'Date of Birth',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                         ),
//                         prefixIcon: Icon(Icons.calendar_today),
//                       ),
//                       validator: _validateNotEmpty,
//                       onTap: () async {
//                         final DateTime? pickedDate = await showDatePicker(
//                           context: context,
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime(1900),
//                           lastDate: DateTime.now(),
//                         );
//                         if (pickedDate != null) {
//                           setState(() {
//                             _dateOfBirthController.text =
//                                 "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
//                           });
//                         }
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: DropdownButtonFormField<String>(
//                       decoration: const InputDecoration(
//                         labelText: 'Select Gender',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                         ),
//                         prefixIcon: Icon(Icons.person_outline),
//                       ),
//                       items: ['Male', 'Female', 'Other']
//                           .map((gender) => DropdownMenuItem<String>(
//                                 value: gender,
//                                 child: Text(gender),
//                               ))
//                           .toList(),
//                       value: _selectedGender,
//                       onChanged: (String? value) {
//                         setState(() {
//                           _selectedGender = value;
//                         });
//                       },
//                       validator: _validateNotEmpty,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 "Health Information",
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w800,
//                     fontSize: 20),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Are you diabetic?',
//                     style: Theme.of(context).textTheme.headline6,
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ListTile(
//                           title: const Text('Yes'),
//                           leading: Radio<String>(
//                             value: 'Yes',
//                             groupValue: _diabeticStatus,
//                             onChanged: _handleDiabeticStatusChange,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: ListTile(
//                           title: const Text('No'),
//                           leading: Radio<String>(
//                             value: 'No',
//                             groupValue: _diabeticStatus,
//                             onChanged: _handleDiabeticStatusChange,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   if (_diabeticStatus == "")
//                     const Text(
//                       'Please select an option',
//                       style: TextStyle(color: Colors.red, fontSize: 12),
//                     ),
//                   AnimatedOpacity(
//                     opacity: _showAdditionalFields ? 1.0 : 0.0,
//                     duration: const Duration(milliseconds: 500),
//                     child: Visibility(
//                       visible: _showAdditionalFields,
//                       child: Column(
//                         children: [
//                           DropdownButtonFormField<String>(
//                             decoration: const InputDecoration(
//                               labelText: 'Type 1/Type 2',
//                               border: OutlineInputBorder(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(10)),
//                               ),
//                             ),
//                             items: ['Type 1', 'Type 2']
//                                 .map((type) => DropdownMenuItem<String>(
//                                       value: type,
//                                       child: Text(type),
//                                     ))
//                                 .toList(),
//                             onChanged: (String? value) {
//                               setState(() {
//                                 _diabetesType = value!;
//                               });
//                             },
//                             value: _diabetesType,
//                             validator: _showAdditionalFields
//                                 ? _validateNotEmpty
//                                 : null,
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           TextFormField(
//                             textAlign: TextAlign.left,
//                             keyboardType:
//                                 const TextInputType.numberWithOptions(),
//                             inputFormatters: <TextInputFormatter>[
//                               LengthLimitingTextInputFormatter(10),
//                               FilteringTextInputFormatter.digitsOnly,
//                               FilteringTextInputFormatter.singleLineFormatter
//                             ],
//                             decoration: const InputDecoration(
//                               labelText: "Glycemic Load Threshold",
//                               border: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Colors.black54,
//                                       style: BorderStyle.solid,
//                                       width: 2),
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(10))),
//                             ),
//                             controller: _glycemicLoadController,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   appState.setName(
//                       _firstNameController.text, _lastNameController.text);
//                   appState.setThreshold(_glycemicLoadController.text);
//                   _submitForm();
//                 },
//                 child: const Text('Submit'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
