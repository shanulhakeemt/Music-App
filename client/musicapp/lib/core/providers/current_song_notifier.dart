import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musicapp/features/home/model/song_model.dart';
import 'package:musicapp/features/home/repositories/home_local_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  late HomeLocalRepository _homeLocalRepository;

  AudioPlayer? audioPlayer;
  bool isPlaying = false;

  Future<void> updateSong(SongModel song) async {
    await audioPlayer?.stop();
    audioPlayer = AudioPlayer();

    final audioSource = AudioSource.uri(Uri.parse(song.songUrl),
        tag: MediaItem(
            id: song.id,
            title: song.songName,
            artist: song.artist,
            artUri: Uri.parse(song.thumbnailUrl)));

    await audioPlayer!.setAudioSource(audioSource);

    audioPlayer!.playerStateStream.listen(
      (state) {
        if (state.processingState == ProcessingState.completed) {
          audioPlayer!.seek(Duration.zero);
          audioPlayer!.pause();
          isPlaying = false;
          this.state = this.state?.copyWith(hexCode: this.state?.hexCode);
        }
      },
    );
    _homeLocalRepository.uploadLocalSong(song);
    audioPlayer!.play();
    isPlaying = true;
    state = song;
  }

  void playPause() {
    if (isPlaying) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.play();
    }
    isPlaying = !isPlaying;
    state = state?.copyWith(hexCode: state?.hexCode);
  }

  void seek(double val) {
    audioPlayer!.seek(Duration(
        milliseconds: (val * audioPlayer!.duration!.inMilliseconds).toInt()));
  }

  @override
  SongModel? build() {
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }
}
