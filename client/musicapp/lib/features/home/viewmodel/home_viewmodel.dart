import 'dart:io';
import 'dart:ui';
import 'package:fpdart/fpdart.dart';
import 'package:musicapp/core/providers/current_user_notifier.dart';
import 'package:musicapp/core/ustils.dart';
import 'package:musicapp/features/home/model/fav_song_model.dart';
import 'package:musicapp/features/home/model/song_model.dart';
import 'package:musicapp/features/home/repositories/home_local_repository.dart';
import 'package:musicapp/features/home/repositories/home_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(GetAllSongsRef ref) async {
  final token = ref.watch(currentUserNotifierProvider.select(
    (user) => user!.token,
  ));
  final res = await ref.watch(homeRepositoryProvider).getAllSongs(token);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<SongModel>> getFavSongs(GetFavSongsRef ref) async {
  final token = ref.watch(currentUserNotifierProvider.select(
    (user) => user!.token,
  ));
  final res = await ref.watch(homeRepositoryProvider).getFavSongs(token);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewmodel extends _$HomeViewmodel {
  late HomeRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;

  @override
  AsyncValue? build() {
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);

    _homeRepository = ref.watch(homeRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required Color selectedColor,
  }) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.uploadSong(
        selectedAudio: selectedAudio,
        selectedThumbnail: selectedThumbnail,
        songName: songName,
        artist: artist,
        hexCode: rgbToHex(selectedColor),
        token: ref.watch(currentUserNotifierProvider)!.token);

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
  }

  Future<void> favSong({
    required String songId,
  }) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.favSong(
        song_id: songId, token: ref.watch(currentUserNotifierProvider)!.token);

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => _favSongSuccess(r, songId),
    };
  }

  AsyncValue _favSongSuccess(bool isFavorited, String songId) {
    final userNotifier = ref.read(currentUserNotifierProvider.notifier);
    if (isFavorited) {
      userNotifier
          .addUser(ref.read(currentUserNotifierProvider)!.copyWith(favorites: [
        ...ref.read(currentUserNotifierProvider)!.favorites,
        FavSongModel(id: '', songId: songId, userId: '')
      ]));
    } else {
      userNotifier.addUser(ref.read(currentUserNotifierProvider)!.copyWith(
          favorites: ref
              .read(currentUserNotifierProvider)!
              .favorites
              .where(
                (fav) => fav.songId != songId,
              )
              .toList()));
    }

    ref.invalidate(getFavSongsProvider);

    return state = AsyncValue.data(isFavorited);
  }

  List<SongModel> getRecentlyPlayedSongs() {
    return _homeLocalRepository.loadSongs();
  }
}
