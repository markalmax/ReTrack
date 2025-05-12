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

  Future<PlaylistModel> getPlaylistData(int playlistId) async {
    if (await Permission.audio.request().isGranted ||
        await Permission.storage.request().isGranted) {
      final playlists = await _audioQuery.queryPlaylists();
      final playlist = playlists.firstWhere(
        (p) => p.id == playlistId,
        orElse:
            () => PlaylistModel({
              '_id': playlistId,
              '_data': '',
              'name': 'Unknown Playlist',
              'date_added': 0,
              'date_modified': 0,
              'date_modified_android': 0,
              'owner_package_name': '',
              'audio_count': 0,
            }),
      );
      return playlist;
    }
    throw Exception('Permission not granted to access playlists.');
  }
}
