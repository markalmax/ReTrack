import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongDetailsPage extends StatelessWidget {
  final SongModel song;
  const SongDetailsPage({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(song.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: SizedBox(
                width: 320,
                height: 320,
                child: QueryArtworkWidget(
                  id: song.id,
                  type: ArtworkType.AUDIO,
                  artworkBorder: BorderRadius.circular(24),
                  nullArtworkWidget: Icon(Icons.music_note, size: 240),
                  size: 320,
                  quality: 100,
                ),
              ),
            ),
            const SizedBox(height: 40),
            ListTile(title: const Text('Title'), subtitle: Text(song.title)),
            ListTile(
              title: const Text('Artist'),
              subtitle: Text(song.artist ?? 'Unknown'),
            ),
            ListTile(
              title: const Text('Album'),
              subtitle: Text(song.album ?? 'Unknown'),
            ),
            ListTile(
              title: const Text('Duration'),
              subtitle: Text('${(song.duration ?? 0) ~/ 1000} seconds'),
            ),
            ListTile(
              title: const Text('Track'),
              subtitle: Text('${song.track ?? '-'}'),
            ),
            ListTile(
              title: const Text('Genre'),
              subtitle: Text(song.genre ?? '-'),
            ),
            ListTile(title: const Text('File Path'), subtitle: Text(song.data)),
            ListTile(title: const Text('ID'), subtitle: Text('${song.id}')),
          ],
        ),
      ),
    );
  }
}
