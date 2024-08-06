import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../core/bloc/base_bloc.dart';
import '../../../../domain/models/path_wrapper.dart';
import '../../../../utils/mixin/event_transformer_mixin.dart';

part 'gallery_event.dart';
part 'gallery_state.dart';

const ThumbnailSize _defaultPathThumbnailSize = ThumbnailSize.square(80);
const int pageSize = 120;

class GalleryBloc extends BaseBloc<GalleryEvent, GalleryState>
    with EventTransformerMixin {
  GalleryBloc() : super(const GalleryState()) {
    on<GalleryGetPaths>(_onGalleryGetPaths);
    on<GalleryGetAssets>(_onGalleryGetAssets);
    on<GalleryGetAssetsWithPage>(
      _onGalleryGetAssetsWithPage,
      transformer: throttleTime(
        const Duration(milliseconds: 100),
      ),
    );
    on<GalleryPathSelected>(_onGalleryPathSelected);
  }

  Future<void> _onGalleryGetPaths(
      GalleryGetPaths event,
      Emitter<GalleryState> emit,
      ) async {
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
      ),
    );

    final List<AssetPathEntity> list = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    List<PathWrapper<AssetPathEntity>> paths =
    await Future.wait<PathWrapper<AssetPathEntity>>(
      list.map(
            (AssetPathEntity p) async {
          PathWrapper<AssetPathEntity> path =
          PathWrapper<AssetPathEntity>(path: p);

          final assetCount = await _getAssetCountFromPath(path);
          path = path.copyWith(assetCount: assetCount);

          final thumbnailData = await _getThumbnailFromPath(path);
          path = path.copyWith(thumbnailData: thumbnailData);

          return path;
        },
      ),
    );

    paths = paths
        .where(
          (path) =>
      path.assetCount != null &&
          path.assetCount! > 0 &&
          path.thumbnailData != null,
    )
        .toList();

    PathWrapper<AssetPathEntity>? currentPath = state.currentPath;
    if (paths.isNotEmpty) {
      currentPath ??= paths.first;
    }

    emit(
      state.copyWith(
        status: FormzSubmissionStatus.success,
        currentPath: currentPath,
        paths: paths,
      ),
    );

    _getAssetsFromCurrentPath();
  }

  Future<void> _onGalleryGetAssets(
      GalleryGetAssets event,
      Emitter<GalleryState> emit,
      ) async {
    PathWrapper<AssetPathEntity>? currentPath = state.currentPath;

    if (currentPath == null || state.paths.isEmpty) {
      emit(state.copyWith(isAssetEmpty: true));
      return;
    }

    final PathWrapper<AssetPathEntity> wrapper = currentPath;
    final int assetCount =
        wrapper.assetCount ?? await wrapper.path.assetCountAsync;
    final isAssetsEmpty = assetCount == 0;
    if (wrapper.assetCount == null) {
      currentPath = currentPath.copyWith(assetCount: assetCount);
    }

    emit(
      state.copyWith(
        isAssetEmpty: isAssetsEmpty,
        currentPath: currentPath,
      ),
    );

    _getAssetsFromPath(0, currentPath.path);
  }

  Future<void> _onGalleryGetAssetsWithPage(
      GalleryGetAssetsWithPage event,
      Emitter<GalleryState> emit,
      ) async {
    int? page = event.page;
    AssetPathEntity? path = event.assetPath;

    final int currentPage = page ?? state.currentAssetsListPage;
    final AssetPathEntity? currentPath = path ?? state.currentPath?.path;
    if (currentPath == null) return;

    final currentAssets = List<AssetEntity>.from(state.currentAssets);

    final List<AssetEntity> list = await currentPath.getAssetListPaged(
      page: currentPage,
      size: pageSize,
    );

    if (currentPage == 0) {
      currentAssets.clear();
    }
    currentAssets.addAll(list);

    emit(
      state.copyWith(
        currentAssets: currentAssets,
      ),
    );
  }

  Future<void> _onGalleryPathSelected(
      GalleryPathSelected event,
      Emitter<GalleryState> emit,
      ) async {
    PathWrapper<AssetPathEntity>? path = event.path;

    if (path == null && state.currentPath == null) {
      return;
    }

    final currentPath = path ?? state.currentPath!;

    emit(
      state.copyWith(
        currentPath: currentPath,
      ),
    );

    _getAssetsFromCurrentPath();
  }

  void getPaths() {
    add(const GalleryGetPaths());
  }

  void onSelectPath(PathWrapper<AssetPathEntity> path) {
    add(GalleryPathSelected(path));
  }

  void onLoadMore() {
    _getAssetsFromPath();
  }

  void _getAssetsFromCurrentPath() {
    add(const GalleryGetAssets());
  }

  void _getAssetsFromPath([int? page, AssetPathEntity? path]) {
    add(GalleryGetAssetsWithPage(page, path));
  }

  Future<int> _getAssetCountFromPath(PathWrapper<AssetPathEntity> path) {
    return path.path.assetCountAsync;
  }

  Future<Uint8List?> _getThumbnailFromPath(
      PathWrapper<AssetPathEntity> path,
      ) async {
    try {
      final int assetCount = path.assetCount ?? await path.path.assetCountAsync;
      if (assetCount == 0) {
        return null;
      }

      final List<AssetEntity> assets = await path.path.getAssetListRange(
        start: 0,
        end: 1,
      );
      if (assets.isEmpty) {
        return null;
      }

      final AssetEntity asset = assets.single;
      if (asset.type != AssetType.image) {
        return null;
      }

      if (asset.width == 0 || asset.height == 0) {
        return null;
      }

      final Uint8List? data = await asset.thumbnailDataWithSize(
        _defaultPathThumbnailSize,
      );

      return data;
    } catch (_) {
      return null;
    }
  }
}
