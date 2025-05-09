import 'dart:io';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaScanner {
  Future<List<SongModel>?> getAllSongs() async {
    if (await Permission.audio.request().isGranted) {
      final OnAudioQuery query = OnAudioQuery();
      return await query.querySongs();
    } else {
      print(await Permission.audio.status);
      return null;
    }
  }
}
