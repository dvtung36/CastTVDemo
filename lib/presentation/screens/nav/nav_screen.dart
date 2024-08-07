import 'dart:async';

import 'package:cast/presentation/screens/home/home_screen.dart';
import 'package:cast/routes.dart';
import 'package:flutter/material.dart';

import '../../../configs/assets.dart';
import 'widgets/bottom_navigation.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  late final PageController _pageController;
  late final StreamController<int> _indexController;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _indexController = StreamController<int>();
    _pages = [
      const HomeScreen(),
      Center(
        child: InkWell(
          onTap: () {
            AppNavigator.push(Routes.gallery);
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.cyan,
              borderRadius: BorderRadius.circular(24),
            ),
            width: 200,
            height: 50,
            child: const Text('Cast Image, Audio'),
          ),
        ),
      ),
    ];
  }

  void _goToPage(int index) {
    _pageController.jumpToPage(index);
    _indexController.add(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _pages,
        onPageChanged: (page) => _indexController.add(page),
      ),
      bottomNavigationBar: StreamBuilder(
        stream: _indexController.stream,
        builder: (context, snapshot) {
          final currentIndex = snapshot.data ?? 0;
          return BottomNavigation(
            items: [
              BottomNavigationItem(
                label: 'Connect TV',
                icon: AppAssets.icHome,
                iconActive: AppAssets.icHomeActive,
              ),
              BottomNavigationItem(
                label: 'Cast Image, Audio',
                icon: AppAssets.icStatistics,
                iconActive: AppAssets.icStatisticsActive,
              ),
            ],
            currentIndex: currentIndex,
            onTap: (index) {
              _goToPage(index);
            },
          );
        },
      ),
    );
  }
}
