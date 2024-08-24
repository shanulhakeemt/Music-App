import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicapp/core/providers/current_user_notifier.dart';
import 'package:musicapp/core/theme/theme.dart';
import 'package:musicapp/features/auth/view/pages/login_page.dart';
import 'package:musicapp/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:musicapp/features/home/view/pages/home_page.dart';
import 'package:musicapp/features/home/view/pages/upload_song_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).initSharedPreferences();

  await container.read(authViewModelProvider.notifier).getData();

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music App',
      theme: AppTheme.darkThemeMode,
      home: currentUser == null ? const LoginPage() : const UploadSongPage(),
    );
  }
}
