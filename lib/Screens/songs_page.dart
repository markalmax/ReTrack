import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:retrack/Services/media_scanner.dart';
import 'package:retrack/Screens/song.dart';

class SongsPage extends StatefulWidget {
  SongsPage({super.key});

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  late Future<List<SongModel>?> _list;
  List<SongModel>? songs;

  @override
  void initState() {
    super.initState();
    final scanner = MediaScanner();
    _list = scanner.getAllSongs();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            SearchAnchor(
              builder: (context, controller) {
                return SearchBar(
                  controller: controller,
                  onTap: () {
                    controller.openView();
                  },
                  onChanged: (_) {
                    controller.openView();
                  },
                  leading: const Icon(Icons.search),
                );
              },
              suggestionsBuilder: (context, controller) {
                return List<ListTile>.generate(5, (int index) {
                  final String item = 'item $index';
                  return ListTile(
                    title: Text(item),
                    onTap: () {
                      setState(() {
                        controller.closeView(item);
                      });
                    },
                  );
                });
              },
            ),
            // TextButton(
            //   onPressed: () async {
            //     final scanner = MediaScanner();
            //     List<SongModel>? trackList = await scanner.getAllSongs();
            //     print(trackList);
            //   },
            //   child: Text("Scan musik"),
            // ),
            Expanded(
              child: FutureBuilder(
                future: _list,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    songs = snapshot.data;
                    if (songs != null && songs!.isNotEmpty) {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: songs!.length,
                        itemBuilder: (_, index) {
                          return ListTile(
                            title: Text(songs![index].title),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          SongDetailsPage(song: songs![index]),
                                ),
                              );
                            },
                          );
                        },
                      );
                    } else {
                      print("data: ");
                      print(snapshot.data);
                      return Text("Sorry");
                    }
                  } else {
                    print("Data2: ");
                    print(snapshot.data);
                    return Text("Sorry");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
