import 'package:flutter/material.dart';
import 'package:glycosafe_v1/components/mealcard_bottomsheet.dart';
import 'package:glycosafe_v1/pages/home_new.dart';
import 'package:google_fonts/google_fonts.dart';

class AddedMealCard extends StatelessWidget {
  const AddedMealCard({
    super.key,
    required this.context,
    required this.isDarkMode,
    required this.width,
    required this.mealName,
    required this.foodDescription,
    required this.allStats,
    required this.imageUrl,
  });

  final BuildContext context;
  final bool isDarkMode;
  final double width;
  final String mealName;
  final foodDescription;
  final List allStats;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Card(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.white, width: 1))),
                  child: Text(mealName,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: isDarkMode ? Colors.grey : Colors.black)),
                ),
                const SizedBox(height: 10),
                for (int i = 0; i < foodDescription.length; i++)
                  MealItem(foodDescription[i]["food_name"],
                      foodDescription[i]["calories"]),
              ],
            ),
          ),
        ),
        onTap: () {
          showModalBottomSheet(
              showDragHandle: true,
              barrierColor: Colors.white.withOpacity(0.15),
              // isDismissible: true,
              // showDragHandle: false,
              // isScrollControlled: true,
              // enableDrag: true,
              backgroundColor: const Color.fromARGB(233, 0, 0, 0),
              context: context,
              builder: (_) => FullMeal(
                    imageUrl: imageUrl,
                    title: mealName,
                    stats: allStats,
                    foodDescription: foodDescription,
                  ));
        });
  }
}
