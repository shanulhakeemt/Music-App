import 'package:musicapp/core/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'current_user_notifier.g.dart';

@Riverpod(keepAlive: true)
class CurrentUserNotifier extends _$CurrentUserNotifier {
  void addUser(UserModel user) {
    state = user;
  }

  @override
  UserModel? build() {
    return null;
  }
}
