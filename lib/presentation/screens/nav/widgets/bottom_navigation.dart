import 'package:flutter/material.dart';

import '../../../../configs/themes/colors.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<BottomNavigationItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: List.generate(
            items.length,
            (index) {
              final item = items[index];

              Color color = const Color(0xFFAFAFBA);
              String icon = item.icon;
              if (index == currentIndex) {
                color = AppColors.primary;
                icon = item.iconActive;
              }

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 12.0,
                    bottom: 14.0,
                  ),
                  child: InkWell(
                    onTap: () => onTap(index),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          icon,
                          width: 32.0,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class BottomNavigationItem {
  final String label;
  final String icon;
  final String iconActive;

  BottomNavigationItem({
    required this.label,
    required this.icon,
    required this.iconActive,
  });
}
