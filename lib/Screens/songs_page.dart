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
                            leading: SizedBox(
                              width: 50,
                              child: QueryArtworkWidget(
                                id: songs![index].id,
                                artworkBorder: BorderRadius.circular(7),
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: Icon(Icons.music_note),
                              ),
                            ),
                            trailing: PopupMenuButton(
                              onSelected: (value) {
                                switch (value) {
                                  case "details":
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => SongDetailsPage(
                                              song: songs![index],
                                            ),
                                      ),
                                    );
                                  default:
                                }
                              },
                              itemBuilder:
                                  (context) => <PopupMenuItem<String>>[
                                    const PopupMenuItem(
                                      value: "details",
                                      child: Text("Details"),
                                    ),
                                  ],
                            ),
                            title: Text(songs![index].title),
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
