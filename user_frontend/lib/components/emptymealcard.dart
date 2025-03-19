import "package:flutter/material.dart";
import "package:glycosafe_v1/providers/appstate_provider.dart";
import "package:provider/provider.dart";

class EmptyMealCard extends StatelessWidget {
  const EmptyMealCard({
    super.key,
    required this.context,
    required this.isDarkMode,
    required this.meal,
  });

  final BuildContext context;
  final bool isDarkMode;
  final String meal;
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<MyAppState>(context, listen: false);

    return Card(
      color: isDarkMode
          ? Colors.white.withOpacity(0.1)
          : Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 25),
        child: Row(
          children: [
            Text(meal,
                style: TextStyle(
                    color: isDarkMode ? Colors.grey : Colors.black,
                    fontSize: 14)),
            const Spacer(),
            IconButton(
              icon: Icon(Icons.add_circle,
                  size: 35, color: Colors.green.withOpacity(0.6)),
              onPressed: () {
                appState.setCurrentPage(context, 2);
              },
            ),
          ],
        ),
      ),
    );
  }
}
