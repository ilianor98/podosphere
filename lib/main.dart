import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:podosphere/favorites.dart';
import 'package:podosphere/todaygames.dart';
import 'package:podosphere/leagues.dart';
import 'package:podosphere/news.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNavPage(),
    );
  }
}

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  _BottomNavPageState createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: PersistentTabController(initialIndex: _currentIndex),
      screens: const [
        TodayGames(),
        Leagues(),
        Favorites(),
        News(),
      ],
      items: [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.calendar_month_outlined),
          title: 'Today',
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.green,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.sports_soccer_sharp),
          title: 'Leagues',
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.green,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.star),
          title: 'Favorites',
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.green,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.newspaper),
          title: 'News',
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.green,
        ),
      ],
      confineInSafeArea: true,
      backgroundColor: const Color(0xFF333333),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: const Color(0xFF333333),
      ),
      popAllScreensOnTapOfSelectedTab: true,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 400),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style6,
      onItemSelected: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}
