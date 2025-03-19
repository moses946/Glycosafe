import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:glycosafe_v1/components/endpoints.dart';

FunctionDeclaration? editPersonalInfoTool;
FunctionDeclaration? getMealsTool;
FunctionDeclaration? addMedicationTool;
FunctionDeclaration? logMealTool;

void initializeAddMedicationTool() {
  print("Initializing Add Medication Tool");
  addMedicationTool = FunctionDeclaration(
      'addMedication',
      'This function adds a medication to the user\'s medication list with the specified details.',
      Schema(SchemaType.object, properties: {
        'medicationName': Schema(SchemaType.string,
            nullable: false,
            description: "The is the name of the medication to be added"),
        'dosage': Schema(SchemaType.string,
            nullable: false,
            description:
                "The is the dosage of the medication, for example, '100mg'"),
        'frequency': Schema(SchemaType.number,
            nullable: false,
            description:
                "This is the frequency of medication intake, for example, 'twice'"),
        'frequencyUnit': Schema(SchemaType.string,
            nullable: false,
            description:
                "This is the unit of frequency, e.g., if a user says something like 'twice a day' the value of this parameter is:'daily'"),
        'startTime': Schema(SchemaType.string,
            nullable: false,
            description:
                "This is the start time for taking the medication, e.g., '08:00am'"),
        'medicationType': Schema(SchemaType.string,
            nullable: false,
            description:
                "This is the form of medication being taken ie if the medication is in form of tablets, pills, liquid or injection"),
        'instructions': Schema(
          SchemaType.string,
          nullable: false,
          description:
              "Additional instructions or notes for taking the medication. Defaults to an empty string if not provided.",
        ),
      }, requiredProperties: [
        'medicationName',
        'dosage',
        'frequency',
        'frequencyUnit',
        'startTime',
        'medicationType'
      ]));
}

void initializeEditPersonalInfoTool() {
  print("running");
  editPersonalInfoTool = FunctionDeclaration(
      'editPersonalInfo',
      'This is a function that updates the user\'s first name, last name, phone number and date of birth(birthdate) in the database',
      Schema(SchemaType.object, properties: {
        'phoneNumber': Schema(SchemaType.number,
            nullable: false,
            description:
                "This is the phone number the user wants to set in their profile information should be 10 digits"),
        'firstName': Schema(SchemaType.string,
            nullable: false,
            description:
                "This is the first name the user wants to set in their profile information "),
        'lastName': Schema(SchemaType.string,
            nullable: false,
            description:
                "This is the last name the user wants to set in their profile information as a string "),
        'dateOfBirth': Schema(SchemaType.string,
            nullable: false,
            description:
                "This is the date the user wants to set as their date of birth in their profile information,Should be in the format `yyyy-MM-dd`"),
      }, requiredProperties: [
        'phoneNumber',
        'firstName',
        'lastName',
        'dateOfBirth'
      ]));
}

// get meals function call
void initializedGetMealsTool() {
  print("initializing get-meals func declaration");
  getMealsTool = FunctionDeclaration(
      "getMeals",
      "This is a function that gets the meals of particular user from the backend",
      Schema(SchemaType.object, properties: {
        "date": Schema(SchemaType.string,
            nullable: false,
            description:
                "This is the date that the user wants to know the meals they ate, pass the date argument  in the form of YYYY-MM-DD, if a user says today they mean today's date and so forth")
      }, requiredProperties: [
        "date"
      ]));
}

void initializeLogMealTool() {
  logMealTool = FunctionDeclaration(
      "logMeal", "This is a function adds a meal to the user's log", null);
}

Future<Map<String, String>> getMeals(
    Map<String, dynamic> args, appState) async {
  print("geting meals");
  var request = http.Request(
      "GET",
      Uri.parse(
          "${Endpoints().get_meals_test}${appState.userId}/?date=${args["date"]}"));
  var response = await request.send();
  if (response.statusCode >= 200 && response.statusCode <= 300) {
    Map<String, String> result = {
      "response": await response.stream.bytesToString()
    };
    return result;
  } else {
    Map<String, String> result = {
      "response": await response.stream.bytesToString()
    };
    return result;
  }
}

Map<String, dynamic> EditInfo(Map<String, dynamic> args, appState) {
  var user = {
    "first_name": args["firstName"] ?? appState.firstName,
    "last_name": args["lastName"] ?? appState.lastName,
    "phone_number": args["phoneNumber"] ?? appState.phoneNumber,
    "date_of_birth": args["dateOfBirth"] ?? appState.birthdate,
  };
  print(user);
  return {"response": "User details set successfully"};
}

Map<String, dynamic> addMedication(Map<String, dynamic> args) {
  print("adding medication");
  var medication = {
    "medication_name": args["medicationName"],
    "dosage": args["dosage"],
    "frequency": args["frequency"],
    "frequency_unit": args["frequencyUnit"],
    "start_time": args["startTime"],
    "medication_type": args["medicationType"],
    "instructions":
        args["instructions"] ?? "", // Use empty string if not provided
  };

  print("New medication added:");
  print(medication);

  return {"response": "Medication added successfully"};
}
