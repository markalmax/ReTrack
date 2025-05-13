import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:retrack/Screens/song.dart';
import 'package:retrack/Services/media_scanner.dart';

class PlaylistDetails extends StatefulWidget {
  final int playlistId;
  const PlaylistDetails({super.key, required this.playlistId});

  @override
  State<PlaylistDetails> createState() => _PlaylistDetailsState();
}

class _PlaylistDetailsState extends State<PlaylistDetails> {
  late Future<List<SongModel>> _songsInPlaylist;
  PlaylistModel? playlistData;
  bool playlistNotFound = false;
  late MediaScanner scanner;

  @override
  void initState() {
    super.initState();
    scanner = MediaScanner();
    _fetchPlaylistData();
    _songsInPlaylist = OnAudioQuery().queryAudiosFrom(
      AudiosFromType.PLAYLIST,
      widget.playlistId,
    );
  }

  Future<void> _fetchPlaylistData() async {
    final playlist = await scanner.getPlaylistData(widget.playlistId);
    setState(() {
      playlistData = playlist;
      playlistNotFound = playlist == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (playlistNotFound) {
      return Scaffold(
        appBar: AppBar(title: const Text('Playlist Not Found')),
        body: const Center(child: Text('This playlist does not exist.')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(playlistData?.playlist ?? 'New Playlist')),
      body: FutureBuilder<List<SongModel>>(
        future: _songsInPlaylist,
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.data!.isEmpty ||
              snapshot.data == null) {
            return const Center(child: Text('No songs found in this playlist'));
          } else {
            final songs = snapshot.data!;
            return ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return ListTile(
                  title: Text(song.title),
                  subtitle: Text(song.artist ?? 'Unknown Artist'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SongDetailsPage(song: song),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
