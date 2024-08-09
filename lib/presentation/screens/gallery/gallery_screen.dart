import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import '../../../routes.dart';
import '../../../utils/extensions/responsive_ext.dart';
import '../../../utils/extensions/scroll_controller_ext.dart';
import '../../blocs/cast/cast_cubit.dart';
import 'bloc/gallery_bloc.dart';
import 'widgets/item_menu_widget.dart';
import 'dart:io';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late final GalleryBloc _galleryBloc;
  late final ScrollController _scrollController;
  late final CastCubit _castCubit;
  bool _showList = false;

  @override
  void initState() {
    super.initState();
    _galleryBloc = context.read<GalleryBloc>();
    _castCubit = context.read<CastCubit>();
    _requestPermission();

    _scrollController = ScrollController();
    _scrollController.onScrollEndListener(() {
      _galleryBloc.onLoadMore();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _requestPermission() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps == PermissionState.authorized || ps == PermissionState.limited) {
      _galleryBloc.getPaths();
    }
  }

  void _handleBack() {
    AppNavigator.pop();
  }

  Future<void> _handleSelectAsset({
    required AssetEntity asset,
  }) async {
    final File? file = await asset.file;

    if (file != null) {
      String path = file.path;
      _castCubit.castImage(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        _handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              _handleBack();
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {
                  setState(() {
                    _showList = !_showList;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 20,
                    right: 16,
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    children: [
                      BlocBuilder<GalleryBloc, GalleryState>(
                        buildWhen: (previous, current) =>
                            previous.currentPath != current.currentPath,
                        builder: (context, state) {
                          String text = '';

                          if (state.currentPath != null) {
                            text = state.currentPath!.path.name;
                          }

                          return Text(
                            text,
                            style: const TextStyle(
                              color: Color(0xFF293444),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.07,
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            IgnorePointer(
              ignoring: _showList,
              child: Column(
                children: [
                  Expanded(
                    child: BlocBuilder<GalleryBloc, GalleryState>(
                      buildWhen: (previous, current) =>
                          previous.currentAssets != current.currentAssets,
                      builder: (context, state) {
                        return GridView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(top: 8),
                          itemCount: state.currentAssets.length,
                          itemBuilder: (context, index) {
                            final asset = state.currentAssets[index];
                            return GestureDetector(
                              onTap: () => _handleSelectAsset(
                                asset: asset,
                              ),
                              child: Image(
                                image: AssetEntityImageProvider(
                                  asset,
                                  isOriginal: false,
                                ),
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (_showList)
              InkWell(
                onTap: () {
                  setState(() {
                    _showList = false;
                  });
                },
                child: Container(
                  height: context.screenHeight,
                  color: Colors.black.withOpacity(0.25),
                  child: Column(
                    children: [
                      BlocBuilder<GalleryBloc, GalleryState>(
                        buildWhen: (previous, current) =>
                            previous.paths != current.paths ||
                            previous.currentPath != current.currentPath,
                        builder: (context, state) {
                          return Container(
                            color: Colors.white,
                            constraints: BoxConstraints(
                              maxHeight: context.screenHeight / 2,
                            ),
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              shrinkWrap: true,
                              itemCount: state.paths.length,
                              separatorBuilder: (_, __) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Container(
                                  height: 0.5,
                                  color:
                                      const Color(0xFF293444).withOpacity(0.1),
                                ),
                              ),
                              itemBuilder: (context, index) {
                                final path = state.paths[index];
                                final isSelected = path == state.currentPath;
                                return ItemMenuWidget(
                                  path: path,
                                  onTap: () {
                                    _galleryBloc.onSelectPath(path);
                                    setState(() {
                                      _showList = false;
                                    });
                                  },
                                  isSelected: isSelected,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
