import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

import '../screen/otherScreen/settingsScreen.dart';
import '../widget/NavigationBar/bottomNavBar.dart';

/* A widget representing the side panel drawer in the app.

 The side panel drawer provides navigation options and settings for the app.
 It includes options such as viewing the user profile, accessing the homepage,
 toggling between light and dark mode, accessing help content, and logging out.*/

class SidePanel extends StatefulWidget {
  final VoidCallback? onDarkModeChanged;

  const SidePanel({Key? key, this.onDarkModeChanged}) : super(key: key);

  @override
  State<SidePanel> createState() => _SidePanelState();
}

class _SidePanelState extends State<SidePanel> {
  final ValueNotifier<bool> _isDarkModeNotifier = ValueNotifier<bool>(false);
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    checkDarkMode();
  }

  @override
  void dispose() {
    _isDarkModeNotifier.dispose();
    super.dispose();
  }

  void checkDarkMode() async {
    bool darkModeValue = await Future.value(false);

    if (_isDarkModeNotifier.value != darkModeValue) {
      setState(() {
        _isDarkModeNotifier.value = darkModeValue;
      });
    }

    print('_isDarkModeNotifier: ${_isDarkModeNotifier.value}');
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width <= 600;
    bool isScrollable = isSmallScreen;

    return Drawer(
      child: Container(
        height: MediaQuery.of(context).size.height / 1,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              physics: isScrollable
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(),
                        child: DrawerHeader(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.lock,
                          size: 28,
                        ),
                        title: Text(
                          'Privacy',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        onTap: () async {
                          const url =
                              'https://www.hs-heilbronn.de/de/exmatrikulation-464d4cf6799a8fe9';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Die Website $url konnte nicht geladen werden.';
                          }
                        },
                      ),
                      ListTile(
                        leading: ValueListenableBuilder<bool>(
                          valueListenable: _isDarkModeNotifier,
                          builder: (BuildContext context, bool value,
                              Widget? child) {
                            return Icon(
                              value
                                  ? Icons.wb_sunny_outlined
                                  : Icons.dark_mode_outlined,
                              size: 28,
                            );
                          },
                        ),
                        title: Text(
                          _isDarkModeNotifier.value
                              ? 'Dark Modus'
                              : 'Light Modus',
                          style: TextStyle(fontSize: 18),
                        ),
                        onTap: () async {
                          _isDarkModeNotifier.value =
                              !_isDarkModeNotifier.value;

                          widget.onDarkModeChanged?.call();

                          SystemChrome.setSystemUIOverlayStyle(
                              SystemUiOverlayStyle());

                          currentIndex = 2;
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.help_outline_outlined,
                          size: 28,
                        ),
                        title: Text(
                          'Help',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          // Save the current index
                          currentIndex = 3;
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.settings,
                          size: 28,
                        ),
                        title: Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          currentIndex = 0;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingsScreen(),
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      ListTile(
                        leading: const Icon(
                          Icons.logout,
                          size: 28,
                        ),
                        title: Text(
                          'Log out',
                          style: TextStyle(fontSize: 18),
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
