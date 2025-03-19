import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glycosafe_v1/components/endpoints.dart';
import 'package:google_fonts/google_fonts.dart';

class FullMeal extends StatelessWidget {
  final String title;
  final List stats;
  final foodDescription;
  final String imageUrl;

  FullMeal(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.stats,
      required this.foodDescription});

  final TextStyle macroStyle = GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: const Color.fromARGB(255, 95, 159, 150)
      // color: Colors.green.withOpacity(0.5)
      );

  Widget MealCard(String foodName, double calories) {
    return Container(
      decoration: BoxDecoration(color: Colors.green.withOpacity(0.7)),
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Icon(
            Icons.circle,
            size: 15,
            color: Color.fromARGB(255, 191, 49, 49),
          ),
          const SizedBox(
            width: 5,
          ),
          Text('$foodName (30g), $calories Cal',
              style: GoogleFonts.inter(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [
        Center(
          child: Text(
            title,
            style: GoogleFonts.inter(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          margin: const EdgeInsets.all(12),
          decoration: const BoxDecoration(shape: BoxShape.circle),
          width: 350,
          height: 150,
          child: CachedNetworkImage(
            // width: 350,
            imageUrl: Endpoints().mainEndpoint + imageUrl.replaceFirst('/', ''),
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        for (int i = 0; i < foodDescription.length; i++)
          MealCard(foodDescription[i]["food_name"],
              (foodDescription[i]["calories"])),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text("Nutritional Facts",
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 124, 86, 42),
                  fontSize: 19)),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.15)),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.white, width: 1.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Calories", style: macroStyle),
                    Text(
                      stats[0].toString(),
                      style: macroStyle,
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.white, width: 1.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Carbs", style: macroStyle),
                    Text(
                      stats[1].toString(),
                      style: macroStyle,
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.white, width: 1.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Protein", style: macroStyle),
                    Text(
                      stats[2].toString(),
                      style: macroStyle,
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.white, width: 1.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Fat", style: macroStyle),
                    Text(
                      stats[3].toString(),
                      style: macroStyle,
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.white, width: 1.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Fibre", style: macroStyle),
                    Text(
                      stats[4].toString(),
                      style: macroStyle,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
