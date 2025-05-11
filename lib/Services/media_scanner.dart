import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaScanner {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<SongModel>> getAllSongs() async {
    if (await Permission.audio.request().isGranted ||
        await Permission.storage.request().isGranted) {
      final OnAudioQuery query = OnAudioQuery();
      return await query.querySongs();
    } else {
      print(await Permission.audio.status);
      return [];
    }
  }

  Future<List<PlaylistModel>> getAllPlaylists() async {
    // Check permissions before querying playlists
    if (await Permission.audio.request().isGranted ||
        await Permission.storage.request().isGranted) {
      return await _audioQuery.queryPlaylists();
    } else {
      print(await Permission.audio.status);
      return [];
    }
  }
}
