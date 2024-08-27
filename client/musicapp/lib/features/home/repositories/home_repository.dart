import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:musicapp/core/constants/server_constants.dart';

class HomeRepository {
  Future<void> uploadSong(File selectedImage,File selectedAudio, ) async {
    final request = http.MultipartRequest(
        'POST', Uri.parse('${ServerConstants.serverUrl}/song/upload'));

    request
      ..files.addAll([
        await http.MultipartFile.fromPath(
            'song', selectedAudio.path),
        await http.MultipartFile.fromPath(
            'thumbnail', selectedImage.path),
      ])
      ..fields.addAll({
        'artist': 'light yagami',
        'song_name': 'l s theme',
        'hex_code': 'FFFFFF',
      })
      ..headers.addAll({
        'x-auth-token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImZkMzVkZjg3LWMyMzgtNGM2Zi05OTUzLTZmZTcxMWJjY2ZkYSJ9.jJ8c7ASp_g70o1PBYI0q8500u8vDDSFcSjw_c6BIZz4'
      });

    final res = await request.send();
    print(res);
  }
}
