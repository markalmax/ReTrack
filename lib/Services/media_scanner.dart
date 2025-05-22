import 'dart:io' show Platform;
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class MediaScanner {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<bool> getPermission() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      bool externalStoragePermission = false;
      externalStoragePermission =
          await Permission.manageExternalStorage.request().isGranted;
      if (androidInfo.version.sdkInt >= 33) {
        return await Permission.audio.request().isGranted &&
            externalStoragePermission;
      }
      return await Permission.storage.request().isGranted;
    } else if (Platform.isIOS) {
      return await Permission.mediaLibrary.request().isGranted;
    } else {
      return false;
    }
  }

  Future<List<SongModel>?> getAllSongs() async {
    if (await getPermission()) {
      final OnAudioQuery query = OnAudioQuery();
      return await query.querySongs();
    } else {
      print(await Permission.audio.status);
      return null;
    }
  }

  Future<List<PlaylistModel>?> getAllPlaylists() async {
    if (await getPermission()) {
      return await _audioQuery.queryPlaylists();
    } else {
      print(await Permission.audio.status);
      return null;
    }
  }

  Future<PlaylistModel?> getPlaylistData(int playlistId) async {
    if (await getPermission()) {
      final playlists = await _audioQuery.queryPlaylists();
      final playlist = playlists.where((p) => p.id == playlistId).toList();
      if (playlist.isNotEmpty) {
        return playlist.first;
      } else {
        return null;
      }
    } else {
      print(await Permission.audio.status);
      return null;
    }
  }

  Future<bool> createPlaylist(String name) async {
    if (await getPermission()) {
      final result = await _audioQuery.createPlaylist(name);
      return result;
    }
    return false;
  }

  Future<bool> removePlaylist(int playlistId) async {
    if (await getPermission()) {
      final result = await _audioQuery.removePlaylist(playlistId);
      return result;
    }
    return false;
  }

  Future<bool> addSongToPlaylist(int playlistId, int songId) async {
    if (await getPermission()) {
      return await _audioQuery.addToPlaylist(playlistId, songId);
    }
    return false;
  }
}
