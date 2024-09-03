import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicapp/core/providers/current_song_notifier.dart';
import 'package:musicapp/core/theme/app_pallete.dart';
import 'package:musicapp/core/widgets/loader.dart';
import 'package:musicapp/features/home/view/pages/upload_song_page.dart';
import 'package:musicapp/features/home/viewmodel/home_viewmodel.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getFavSongsProvider).when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length + 1,
            itemBuilder: (context, index) {
              if (index == data.length) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UploadSongPage(),
                        ));
                  },
                  leading: const CircleAvatar(
                    radius: 35,
                    backgroundColor: Pallete.backgroundColor,
                    child: Icon(CupertinoIcons.plus),
                  ),
                  title: const Text(
                    "Upload New Song",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                );
              }
              final song = data[index];
              return ListTile(
                onTap: () {
                  ref
                      .read(currentSongNotifierProvider.notifier)
                      .updateSong(song);
                },
                leading: CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(song.thumbnailUrl),
                    backgroundColor: Pallete.backgroundColor),
                title: Text(
                  song.songName,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  song.artist,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const Loader());
  }
}
