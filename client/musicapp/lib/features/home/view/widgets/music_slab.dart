import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicapp/core/providers/current_song_notifier.dart';
import 'package:musicapp/core/providers/current_user_notifier.dart';
import 'package:musicapp/core/theme/app_pallete.dart';
import 'package:musicapp/core/ustils.dart';
import 'package:musicapp/features/home/view/widgets/music_player.dart';
import 'package:musicapp/features/home/viewmodel/home_viewmodel.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);
    final userFavorites = ref.watch(currentUserNotifierProvider.select(
      (value) => value!.favorites,
    ));
    if (currentSong == null) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return const MusicPlayer();
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                final tween = Tween(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeIn));

                final offsetAnimation = animation.drive(tween);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ));
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: hexToColor(currentSong.hexCode)),
            padding: const EdgeInsets.all(9),
            height: 66,
            width: MediaQuery.of(context).size.width - 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: 'music-image',
                      child: Container(
                        width: 48,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            image: DecorationImage(
                                image: NetworkImage(currentSong.thumbnailUrl),
                                fit: BoxFit.cover)),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(currentSong.songName,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        Text(currentSong.songName,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Pallete.subtitleText))
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () async {
                          await ref
                              .read(homeViewmodelProvider.notifier)
                              .favSong(songId: currentSong.id);
                        },
                        icon: Icon(
                          userFavorites
                                  .where(
                                    (fav) => fav.songId == currentSong.id,
                                  )
                                  .toList()
                                  .isNotEmpty
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: Pallete.whiteColor,
                        )),
                    IconButton(
                        onPressed: songNotifier.playPause,
                        icon: Icon(
                            songNotifier.isPlaying
                                ? CupertinoIcons.pause_fill
                                : CupertinoIcons.play_fill,
                            color: Pallete.whiteColor))
                  ],
                ),
              ],
            ),
          ),
          StreamBuilder(
              stream: songNotifier.audioPlayer?.positionStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }
                final position = snapshot.data;

                final duration = songNotifier.audioPlayer!.duration;

                double sliderValue = 0.0;
                if (position != null && duration != null) {
                  sliderValue =
                      position.inMilliseconds / duration.inMilliseconds;
                }

                return Positioned(
                    bottom: 0,
                    left: 8,
                    child: Container(
                      height: 2,
                      width: sliderValue *
                          (MediaQuery.of(context).size.width - 32),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Pallete.whiteColor),
                    ));
              }),
          Positioned(
              bottom: 0,
              left: 8,
              child: Container(
                height: 2,
                width: MediaQuery.of(context).size.width - 32,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Pallete.inactiveSeekColor),
              ))
        ],
      ),
    );
  }
}
