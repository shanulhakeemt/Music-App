import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicapp/core/constants/asset_constants.dart';
import 'package:musicapp/core/providers/current_song_notifier.dart';
import 'package:musicapp/core/theme/app_pallete.dart';
import 'package:musicapp/core/ustils.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            hexToColor(currentSong!.hexCode),
            const Color(0xff121212)
          ])),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Scaffold(
        backgroundColor: Pallete.transparentColor,
        appBar: AppBar(
          backgroundColor: Pallete.transparentColor,
          leading: Transform.translate(
            offset: const Offset(-15, 0),
            child: InkWell(
              highlightColor: Pallete.transparentColor,
              focusColor: Pallete.transparentColor,
              splashColor: Pallete.transparentColor,
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  AssetConstants.pullDownArrowIcon,
                  color: Pallete.whiteColor,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Hero(
                  tag: 'music-image',
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(currentSong!.thumbnailUrl),
                            fit: BoxFit.cover)),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.songName,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Pallete.whiteColor),
                          ),
                          Text(
                            currentSong.songName,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Pallete.subtitleText),
                          )
                        ],
                      ),
                      const Expanded(child: SizedBox()),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            CupertinoIcons.heart,
                            color: Pallete.whiteColor,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  StreamBuilder(
                      stream: songNotifier.audioPlayer!.positionStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        }
                        final position = snapshot.data;

                        final duration = songNotifier.audioPlayer!.duration;

                        double sliderValue = 0.0;
                        if (position != null && duration != null) {
                          sliderValue =
                              position.inMilliseconds / duration.inMilliseconds;
                        }

                        return Column(
                          children: [
                            StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: Pallete.whiteColor,
                                    inactiveTrackColor:
                                        Pallete.whiteColor.withOpacity(0.117),
                                    thumbColor: Pallete.whiteColor,
                                    overlayShape:
                                        SliderComponentShape.noOverlay,
                                    trackHeight: 4),
                                child: Slider(
                                  min: 0,
                                  max: 1,
                                  value: sliderValue,
                                  onChanged: (value) {
                                    sliderValue = value;
                                    setState;
                                  },
                                  onChangeEnd: (value) {
                                    songNotifier.seek(value);
                                    setState;
                                  },
                                ),
                              );
                            }),
                            Row(
                              children: [
                                Text(
                                  "${position?.inMinutes}:${(position?.inSeconds ?? 0) < 10 ? '0${position?.inSeconds}' : position?.inSeconds}",
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                      color: Pallete.subtitleText),
                                ),
                                const Expanded(child: SizedBox()),
                                Text(
                                  "${duration?.inMinutes}:${(duration?.inSeconds ?? 0) < 10 ? '0${duration?.inSeconds}' : duration?.inSeconds}",
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                      color: Pallete.subtitleText),
                                )
                              ],
                            ),
                          ],
                        );
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          AssetConstants.shuffleIcon,
                          color: Pallete.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          AssetConstants.previusSongIcon,
                          color: Pallete.whiteColor,
                        ),
                      ),
                      IconButton(
                          onPressed: songNotifier.playPause,
                          icon: Icon(
                            songNotifier.isPlaying
                                ? CupertinoIcons.pause_circle_fill
                                : CupertinoIcons.play_circle_fill,
                            size: 80,
                            color: Pallete.whiteColor,
                          )),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          AssetConstants.nextSongIcon,
                          color: Pallete.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          AssetConstants.repeatIcon,
                          color: Pallete.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          AssetConstants.connectDeviceImage,
                          color: Pallete.whiteColor,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          AssetConstants.playlistIcon,
                          color: Pallete.whiteColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
