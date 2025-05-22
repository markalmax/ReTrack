import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:retrack/Services/media_scanner.dart';
import 'package:retrack/Screens/playlist.dart';
//import 'package:retrack/Screens/song.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  //final OnAudioQuery _audioQuery = OnAudioQuery();
  //late Future<List<SongModel>?> _list;
  late List<SongModel> songs;
  List<PlaylistModel> playlists = [];
  late MediaScanner scanner;

  @override
  void initState() {
    super.initState();
    scanner = MediaScanner();
    //_list = scanner.getAllSongs();
    _fetchPlaylists();
  }

  Future<void> _fetchPlaylists() async {
    final result = await scanner.getAllPlaylists();
    setState(() {
      playlists = result!.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          playlists.isEmpty
              ? const Center(child: Text('No playlists found.'))
              : ListView.builder(
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  final playlist = playlists[index];
                  return ListTile(
                    leading: const Icon(Icons.queue_music),
                    title: Text(playlist.playlist),
                    subtitle: Text('${playlist.numOfSongs} songs'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  PlaylistDetails(playlistId: playlist.id),
                        ),
                      );
                      print(playlist.id);
                      print(playlist.playlist);
                    },
                    onLongPress: () async {
                      final delete = await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Delete Playlist'),
                            content: const Text(
                              'Are you sure you want to delete this playlist?',
                            ),
                            actions: [
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(true),
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                      if (delete == true) {
                        final result = await scanner.removePlaylist(
                          playlist.id,
                        );
                        if (result == true) {
                          _fetchPlaylists();
                        } else {
                          print("Failed to delete playlist");
                        }
                      }
                    },
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? playlistName = await showDialog<String>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Create Playlist'),
                content: TextField(
                  autofocus: true,
                  decoration: const InputDecoration(hintText: 'New Playlist'),
                  onSubmitted: (value) => Navigator.of(context).pop(value),
                ),
              );
            },
          );
          if (playlistName != null && playlistName.trim().isNotEmpty) {
            await scanner.createPlaylist(playlistName.trim());
            _fetchPlaylists();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
