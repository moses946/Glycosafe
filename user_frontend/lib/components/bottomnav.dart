import 'package:flutter/material.dart';
import 'package:glycosafe_v1/providers/appstate_provider.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _NavBar();
  }
}

class _NavBar extends StatefulWidget {
  const _NavBar({Key? key}) : super(key: key);

  @override
  __NavBarState createState() => __NavBarState();
}

class __NavBarState extends State<_NavBar> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var selectedIndex = appState.defaultPage;
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 20.0, left: 15, right: 15, top: 20),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            BottomNavigationBar(
              elevation: 1,
              backgroundColor: Colors.black,
              type: BottomNavigationBarType.fixed,
              // selectedItemColor: Color.fromRGBO(255, 224, 130, 1),
              selectedItemColor: const Color.fromARGB(255, 255, 132, 0),
              unselectedItemColor: const Color.fromARGB(205, 255, 132, 0),
              selectedFontSize: 12,
              showUnselectedLabels: false,

              currentIndex: appState.defaultPage,
              onTap: (index) => {
                appState.setCurrentPage(context, index),
              },
              items: [
                BottomNavigationBarItem(
                  icon: selectedIndex == 0
                      ? const Icon(
                          Icons.home_filled,
                        )
                      : const Icon(Icons.home_outlined),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: selectedIndex == 1
                      ? const Icon(Icons.auto_awesome)
                      : const Icon(Icons.auto_awesome_outlined),
                  label: "Rafiki",
                ),
                const BottomNavigationBarItem(
                  icon: SizedBox.shrink(),
                  label: "", // Empty space for camera
                ),
                BottomNavigationBarItem(
                  icon: selectedIndex == 3
                      ? const Icon(Icons.article)
                      : const Icon(Icons.article_outlined),
                  label: "Articles",
                ),
                BottomNavigationBarItem(
                  icon: selectedIndex == 4
                      ? const Icon(Icons.settings)
                      : const Icon(Icons.settings_outlined),
                  label: "Settings",
                ),
              ],
            ),
            Positioned(
                bottom: 1,
                child: FloatingActionButton(
                    heroTag: 'Camera',
                    backgroundColor:
                        const Color.fromARGB(255, 58, 55, 55).withAlpha(255),
                    // appState.defaultPage == 2
                    //     ? const Color.fromARGB(164, 63, 63, 63)
                    //     : Colors.black,
                    onPressed: () {
                      appState.setCurrentPage(context, 2);
                    },
                    child:
                        // appState.defaultPage == 2
                        const Icon(Icons.camera_alt,
                            size: 40, color: Color.fromARGB(255, 255, 132, 0)))
                // : Icon(Icons.camera_alt_outlined,
                //     size: 40, color: Color.fromARGB(255, 255, 132, 0))),
                ),
          ],
        ),
      ),
    );
  }
}
