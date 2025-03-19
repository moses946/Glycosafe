import 'package:flutter/material.dart';
import 'package:glycosafe_v1/providers/appstate_provider.dart';
import 'package:glycosafe_v1/components/bottomnav.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:glycosafe_v1/components/labeledImage.dart';
import 'package:glycosafe_v1/components/profile_picture.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class homeDashboard extends StatelessWidget {
  const homeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(children: [
        Dashboard(),
        Align(alignment: Alignment.bottomCenter, child: BottomNav())
      ]),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime _selectedDate = DateTime.now();

  String formatDate(DateTime date) {
    DateTime now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return "Today";
    } else if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.subtract(const Duration(days: 1)).day) {
      return "Yesterday";
    } else {
      return DateFormat('EEEE').format(date); // Returns the day of the week
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final today = DateTime.now();
    var appState = context.watch<MyAppState>();
    var timeList = ["08:00", "13:00", "19:00"];
    return SafeArea(
      child: ListView(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(84, 230, 230, 230),
              ),
              height: height * 0.3,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 5, left: 10, right: 10, bottom: 10),
                child: Column(children: [
                  ListTile(
                    title: Text(
                        "${DateFormat("EEEE").format(today)}, ${DateFormat("d MMMM").format(today)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        )),
                    subtitle: Text(
                      "Hello,${appState.firstName}",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.black),
                    ),
                    trailing: SizedBox(
                      height: 50,
                      width: 50,
                      child: ProfilePicture(firstName: appState.firstName),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            formatDate(_selectedDate),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 90,
                    child: DatePicker(
                      DateTime.now().subtract(const Duration(days: 4)),
                      initialSelectedDate: _selectedDate,
                      selectionColor: Colors.white,
                      selectedTextColor: Colors.black,
                      daysCount: 5,
                      // height: 30,
                      // width: 25,
                      onDateChange: (date) {
                        _selectedDate = date;
                        setState(() {});
                      },
                    ),
                  )
                ]),
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(143, 17, 14, 14),
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircularProgress(
                    color: Colors.orange,
                    nutrient: "Kcal",
                    width: 100,
                    calories: 100,
                    progress: 0.5),
                CircularProgress(
                    color: Colors.orange,
                    nutrient: "Carbs",
                    width: 70,
                    calories: 100,
                    progress: 0.7),
                CircularProgress(
                    color: Colors.orange,
                    nutrient: "Protein",
                    width: 70,
                    calories: 100,
                    progress: 0.4),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Meals",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/history");
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 15),
                    child: const Row(
                      children: [
                        Text(
                          "View Full History",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              for (int i = 0; i < 3; i++) MealView(time: timeList[i]),
            ],
          ),
          // Container(
          //   height: height * 0.35,
          //   padding: const EdgeInsets.only(top: 20),
          //   color: Colors.white,
          //   child: const Info(),
          // ),
          Container(height: height * 0.15, color: Colors.grey[400])
        ],
      ),
    );
  }
}

class MealView extends StatelessWidget {
  final String time;
  const MealView({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
      child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(152, 174, 212, 217),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            // boxShadow: [
            //   BoxShadow(
            //     color: Color.fromARGB(47, 0, 0, 0),
            //     spreadRadius: 2,
            //     blurRadius: 2,
            //     blurStyle: BlurStyle.normal,
            //   )
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Image.asset(
                  "assets/images/labeled_food.jpg",
                  width: 100,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [Icon(Icons.remove), Text("Rice")],
                    ),
                    Row(
                      children: [Icon(Icons.remove), Text("Minji Stew")],
                    ),
                    Row(
                      children: [Icon(Icons.remove), Text("Avocado")],
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 50,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.history,
                          color: Colors.grey,
                          size: 12,
                        ),
                        Text(
                          time,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}

// Stack(
//         children: [
//           Positioned(
//               top: 0,
//               left: 0,
//               right: 0,
//               height: height * 0.35,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     color: Color.fromARGB(84, 230, 230, 230),
//                   ),
//                   height: height * 0.25,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
//                     child: Column(children: [
//                       ListTile(
//                         title: Text(
//                             "${DateFormat("EEEE").format(today)}, ${DateFormat("d MMMM").format(today)}",
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w400,
//                               fontSize: 13,
//                             )),
//                         subtitle: Text(
//                           "Hello,${appState.firstName}",
//                           style: const TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.w800,
//                               color: Colors.black),
//                         ),
//                         trailing: Container(
//                           height: 50,
//                           width: 50,
//                           child: ProfilePicture(firstName: appState.firstName),
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Container(
//                               alignment: Alignment.centerLeft,
//                               padding: const EdgeInsets.only(left: 15),
//                               child: Text(
//                                 formatDate(_selectedDate),
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.pushNamed(context, "/history");
//                             },
//                             child: Container(
//                               alignment: Alignment.centerRight,
//                               padding: const EdgeInsets.only(right: 15),
//                               child: const Text(
//                                 "History",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       ClipRect(
//                         child: DatePicker(
//                           DateTime.now().subtract(const Duration(days: 4)),
//                           initialSelectedDate: _selectedDate,
//                           selectionColor: Colors.white,
//                           selectedTextColor: Colors.black,
//                           daysCount: 5,
//                           // height: 30,
//                           // width: 25,
//                           onDateChange: (date) {
//                             _selectedDate = date;
//                             setState(() {});
//                           },
//                         ),
//                       )
//                     ]),
//                   ),
//                 ),
//               )),
//           Positioned(
//             left: 0,
//             right: 0,
//             top: height * 0.3,
//             height: height * 0.35,
//             child: Container(
//               padding: const EdgeInsets.only(top: 20),
//               color: Colors.white,
//               child: const Info(),
//             ),
//           ),
//           Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               height: height * 0.2,
//               child: Container(color: Colors.grey[400]))
//         ],