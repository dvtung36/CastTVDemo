import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../configs/assets.dart';
import '../../../../domain/models/path_wrapper.dart';

class ItemMenuWidget extends StatelessWidget {
  const ItemMenuWidget({
    super.key,
    required this.path,
    required this.onTap,
    this.isSelected = false,
  });

  final PathWrapper<AssetPathEntity> path;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: () {
              if (path.thumbnailData != null) {
                return Image.memory(
                  path.thumbnailData!,
                  width: 62,
                  height: 62,
                  fit: BoxFit.cover,
                );
              }

              return Container(
                width: 62,
                height: 62,
                color: Colors.amber,
              );
            }(),
          ),
          const SizedBox(
            width: 14,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  path.path.name,
                  style: const TextStyle(
                    color: Color(0xFF293444),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '${path.assetCount ?? 0}',
                  style: const TextStyle(
                    color: Color(0xFF969EAA),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
          if (isSelected)
            Container(
              width: 24,
              height: 24,
              color: Colors.amber,
            ),
        ],
      ),
    );
  }
}
