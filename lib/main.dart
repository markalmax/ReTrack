import 'package:flutter/material.dart';

import 'package:retrack/Screens/songs_page.dart';

void main() {
  runApp(StartPage());
}

class StartPage extends StatefulWidget {
  StartPage({super.key});
  final Map<int, String> pageNames = {
    0: 'Home',
    1: 'Music',
    2: 'Albums',
    3: 'Playlists',
  };

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(colorScheme: const ColorScheme.light()),
      darkTheme: ThemeData.from(colorScheme: const ColorScheme.dark()),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.pageNames[selectedIndex]!),
        ),
        bottomNavigationBar: NavigationBar(
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.music_note), label: 'Music'),
            NavigationDestination(icon: Icon(Icons.album), label: 'Albums'),
            NavigationDestination(
              icon: Icon(Icons.queue_music),
              label: 'Playlists',
            ),
          ],
          selectedIndex: selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
        body:
            [Container(), SongsPage(), Container(), Container()][selectedIndex],
      ),
    );
  }
}
