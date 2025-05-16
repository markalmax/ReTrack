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
      child: FutureBuilder(
        future: _list,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            songs = snapshot.data;
            if (songs == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: const [
                      Icon(Icons.heart_broken, size: 100),
                      Text("Please Grant Permissions to access music files."),
                    ],
                  ),
                ),
              );
            } else if (songs!.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: const [
                      Icon(Icons.sentiment_dissatisfied, size: 100),
                      Text("Couldn't find any audio files."),
                    ],
                  ),
                ),
              );
            } else {
              return Column(
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
                      final text = controller.text.toLowerCase();
                      final result =
                          songs!
                              .where(
                                (song) =>
                                    song.title.toLowerCase().contains(text),
                              )
                              .toList();
                      return result.map(
                        (song) => ListTile(
                          title: Text(
                            song.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: SizedBox(
                            width: 50,
                            child: QueryArtworkWidget(
                              id: song.id,
                              artworkBorder: BorderRadius.circular(7),
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: Icon(Icons.music_note),
                            ),
                          ),
                          onTap: () => controller.closeView(song.title),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
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
                                case "addplaylist":
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      final scanner = MediaScanner();
                                      return FutureBuilder<
                                        List<PlaylistModel>?
                                      >(
                                        future: scanner.getAllPlaylists(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData ||
                                              snapshot.data == null ||
                                              snapshot.data!.isEmpty) {
                                            return AlertDialog(
                                              title: Text("Add to Playlist"),
                                              content: Text(
                                                "No playlists found.",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                      ),
                                                  child: Text("Close"),
                                                ),
                                              ],
                                            );
                                          }
                                          final playlists = snapshot.data!;
                                          return AlertDialog(
                                            title: Text("Add to Playlist"),
                                            content: SizedBox(
                                              width: double.maxFinite,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: playlists.length,
                                                itemBuilder: (context, idx) {
                                                  final playlist =
                                                      playlists[idx];
                                                  return ListTile(
                                                    title: Text(
                                                      playlist.playlist,
                                                    ),
                                                    onTap: () async {
                                                      final added = await scanner
                                                          .addSongToPlaylist(
                                                            playlist.id,
                                                            songs![index].id,
                                                          );
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            added
                                                                ? 'Song added to "${playlist.playlist}"'
                                                                : 'Failed to add song.',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
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
                                  const PopupMenuItem(
                                    value: "addplaylist",
                                    child: Text("Add to Playlist"),
                                  ),
                                ],
                          ),
                          title: Text(
                            songs![index].title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            songs![index].artist ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 16,
                  children: const [
                    Text("Searching for Audio Files"),
                    LinearProgressIndicator(value: null),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
