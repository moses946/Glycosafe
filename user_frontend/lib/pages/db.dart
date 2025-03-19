import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = p.join(await getDatabasesPath(), 'glycosafe_database2.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<bool> databaseExists() async {
    String path = p.join(await getDatabasesPath(), 'glycosafe_database2.db');
    return databaseFactory.databaseExists(path);
  }

  Future _onCreate(Database db, int version) async {
    print("oncreate called");
    await db.execute(
        'CREATE TABLE Profile(user_id INT, firstName TEXT, lastName TEXT, DOB TEXT, email TEXT, phoneNumber TEXT, diabetesStatus TEXT, diabetesType TEXT, gender TEXT, weight TEXT)');
    await db.execute(
      'CREATE TABLE meals(id INTEGER PRIMARY KEY AUTOINCREMENT, meal_date TEXT)',
    );
    await db.execute(
      'CREATE TABLE badges(id INTEGER PRIMARY KEY AUTOINCREMENT, badge_name TEXT, date_awarded TEXT)',
    );
    await db.execute(
      'CREATE TABLE Medications(medication_id TEXT, medication_name TEXT, dosage TEXT, frequency INT, start_time TEXT, icon TEXT,  frequency_unit TEXT, instruction TEXT)',
    );
  }

  // Method to add profile info
  Future<void> addProfile(
      {required int userId,
      required String weight,
      required String firstName,
      required String lastName,
      required String DOB,
      required String email,
      required String phoneNumber,
      required String diabetesStatus,
      required String gender,
      required String diabetesType}) async {
    final db = await database;
    db.insert("Profile", {
      "user_id": userId,
      'firstName': firstName,
      'lastName': lastName,
      'DOB': DOB,
      'email': email,
      'phoneNumber': phoneNumber,
      'diabetesStatus': diabetesStatus,
      'diabetesType': diabetesType,
      'gender': gender,
      'weight': weight,
    });
  }

  Future<void> addMedication(
      {required String medication_name,
      required String icon,
      required String start_time,
      required int frequency,
      required String dosage,
      required String instruction,
      required String frequency_unit,
      required String medication_id}) async {
    final db = await database;
    db.insert("Medications", {
      "medication_id": medication_id,
      "medication_name": medication_name,
      'icon': icon,
      'start_time': start_time,
      'frequency': frequency,
      'dosage': dosage,
      "frequency_unit": frequency_unit,
      "instruction": instruction
    });
  }

  Future<void> deleteMedication(String medicationId) async {
    final db = await database;
    db.delete('Medications',
        where: 'medication_id = ?', whereArgs: [medicationId]);
  }

  Future<void> updateProfile(int userId, String firstName, String lastName,
      String dob, String phoneNumber) async {
    final db = await database;
    db.update(
      'Profile',
      {
        'firstName': firstName,
        'lastName': lastName,
        'DOB': dob,
        'phoneNumber': phoneNumber,
      },
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> deleteDatabaseFile() async {
    String path = p.join(await getDatabasesPath(), 'glycosafe_database2.db');
    deleteDatabase(path);
    _database = null;
  }

  // Method to log a meal
  Future<void> logMeal(String mealDate) async {
    final db = await database;
    await db.insert('meals', {'meal_date': mealDate});
  }

  // Method to award a badge
  Future<void> awardBadge(String badgeName) async {
    final db = await database;
    await db.insert('badges', {
      'badge_name': badgeName,
      'date_awarded': DateTime.now().toIso8601String()
    });
  }

  // Method to get Profile information
  Future<List<Map<String, dynamic>>> getProfile() async {
    final db = await database;
    return await db.query("Profile");
  }

  Future<List<Map<String, Object?>>> getMedications() async {
    final db = await database;
    return await db.query("Medications");
  }

  // Method to get the meal logs
  Future<List<Map<String, dynamic>>> getMealLogs() async {
    final db = await database;
    return await db.query('meals');
  }

  // Method to get the awarded badges
  Future<List<Map<String, dynamic>>> getAwardedBadges() async {
    final db = await database;
    return await db.query('badges');
  }
}

Future<void> checkForBadges() async {
  final mealLogs = await DatabaseHelper().getMealLogs();
  final awardedBadges = await DatabaseHelper().getAwardedBadges();

  if (!_hasBadge(awardedBadges, 'Daily Logger')) {
    if (_meetsDailyLoggerCriteria(mealLogs)) {
      await DatabaseHelper().awardBadge('Daily Logger');
    }
  }

  if (!_hasBadge(awardedBadges, 'Consistency Champion')) {
    if (_meetsConsistencyChampionCriteria(mealLogs)) {
      await DatabaseHelper().awardBadge('Consistency Champion');
    }
  }

  if (!_hasBadge(awardedBadges, 'Meal Tracker')) {
    if (_meetsMealTrackerCriteria(mealLogs)) {
      await DatabaseHelper().awardBadge('Meal Tracker');
    }
  }
}

bool _hasBadge(List<Map<String, dynamic>> awardedBadges, String badgeName) {
  return awardedBadges.any((badge) => badge['badge_name'] == badgeName);
}

bool _meetsDailyLoggerCriteria(List<Map<String, dynamic>> mealLogs) {
  final now = DateTime.now();
  for (int i = 0; i < 7; i++) {
    final dateToCheck =
        now.subtract(Duration(days: i)).toIso8601String().split('T')[0];
    if (!mealLogs
        .any((meal) => meal['meal_date'].split('T')[0] == dateToCheck)) {
      return false;
    }
  }
  return true;
}

bool _meetsConsistencyChampionCriteria(List<Map<String, dynamic>> mealLogs) {
  final now = DateTime.now();
  for (int i = 0; i < 30; i++) {
    final dateToCheck =
        now.subtract(Duration(days: i)).toIso8601String().split('T')[0];
    if (!mealLogs
        .any((meal) => meal['meal_date'].split('T')[0] == dateToCheck)) {
      return false;
    }
  }
  return true;
}

bool _meetsMealTrackerCriteria(List<Map<String, dynamic>> mealLogs) {
  return mealLogs.length >= 100;
}

Future<void> checkForMilestoneBadges() async {
  final mealLogs = await DatabaseHelper().getMealLogs();
  final awardedBadges = await DatabaseHelper().getAwardedBadges();

  if (!_hasBadge(awardedBadges, 'First Meal')) {
    if (_meetsFirstMealCriteria(mealLogs)) {
      await DatabaseHelper().awardBadge('First Meal');
    }
  }

  if (!_hasBadge(awardedBadges, '10th Meal')) {
    if (_meets10thMealCriteria(mealLogs)) {
      await DatabaseHelper().awardBadge('10th Meal');
    }
  }

  if (!_hasBadge(awardedBadges, '50th Meal')) {
    if (_meets50thMealCriteria(mealLogs)) {
      await DatabaseHelper().awardBadge('50th Meal');
    }
  }
}

bool _meetsFirstMealCriteria(List<Map<String, dynamic>> mealLogs) {
  return mealLogs.isNotEmpty;
}

bool _meets10thMealCriteria(List<Map<String, dynamic>> mealLogs) {
  return mealLogs.length >= 10;
}

bool _meets50thMealCriteria(List<Map<String, dynamic>> mealLogs) {
  return mealLogs.length >= 50;
}

// to be run whenever a meal is logged and to check for badges
void logMeal(String mealDate) async {
  await DatabaseHelper().logMeal(mealDate);
  await checkForBadges();
  await checkForMilestoneBadges();
}
