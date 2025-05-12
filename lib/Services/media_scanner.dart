import 'dart:io' show Platform;

import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaScanner {
  Future<List<SongModel>?> getAllSongs() async {
    bool isAllowed = false;

    if (Platform.isAndroid) {
      isAllowed =
          await Permission.audio.request().isGranted ||
          await Permission.storage.request().isGranted;
    } else {
      isAllowed = await Permission.mediaLibrary.request().isGranted;
    }

    if (isAllowed) {
      final OnAudioQuery query = OnAudioQuery();
      return await query.querySongs();
    } else {
      print(await Permission.audio.status);
      return null;
    }
  }
}
