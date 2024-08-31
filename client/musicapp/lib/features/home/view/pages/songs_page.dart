import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicapp/core/providers/current_song_notifier.dart';
import 'package:musicapp/core/theme/app_pallete.dart';
import 'package:musicapp/core/widgets/loader.dart';
import 'package:musicapp/features/home/viewmodel/home_viewmodel.dart';

class SongsPage extends ConsumerWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Latest Today',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 23),
          ),
        ),
        ref.watch(getAllSongsProvider).when(
              data: (songs) {
                return SizedBox(
                  height: 260,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];

                      return GestureDetector(
                        onTap: () {
                          ref
                              .read(currentSongNotifierProvider.notifier)
                              .updateSong(song);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 180,
                                width: 180,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    image: DecorationImage(
                                        image: NetworkImage(song.thumbnailUrl),
                                        fit: BoxFit.cover)),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: 180,
                                child: Text(
                                  song.songName,
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(
                                width: 180,
                                child: Text(
                                  song.artist,
                                  style: const TextStyle(
                                      color: Pallete.subtitleText,
                                      fontSize: 13,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              error: (error, stackTrace) => Center(
                child: Text(error.toString()),
              ),
              loading: () => const Loader(),
            )
      ],
    ));
  }
}
