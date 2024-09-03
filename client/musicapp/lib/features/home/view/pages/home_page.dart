import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicapp/core/constants/asset_constants.dart';
import 'package:musicapp/core/theme/app_pallete.dart';
import 'package:musicapp/features/home/view/pages/library_page.dart';
import 'package:musicapp/features/home/view/pages/songs_page.dart';
import 'package:musicapp/features/home/view/widgets/music_slab.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selectedIndex = 0;
  
  final pages = const [SongsPage(), LibraryPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (value) {

            setState(() {
              selectedIndex = value;
            });

          },
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                selectedIndex == 0
                    ? AssetConstants.homeFilledIcon
                    : AssetConstants.homeUnfilledIcon,
                color: selectedIndex == 0
                    ? Pallete.whiteColor
                    : Pallete.inactiveBottomBarItemColor,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
                icon: Image.asset(
                  AssetConstants.libraryIcon,
                  color: selectedIndex == 1
                      ? Pallete.whiteColor
                      : Pallete.inactiveBottomBarItemColor,
                ),
                label: 'Library'),
          ],
        ),
        body: Stack(
          children: [
            pages[selectedIndex],
            const Positioned(bottom: 0, child: MusicSlab())
          ],
        ));
  }
}
