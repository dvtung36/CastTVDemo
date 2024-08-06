part of 'gallery_bloc.dart';

class GalleryState extends Equatable {
  const GalleryState({
    this.status = FormzSubmissionStatus.initial,
    this.currentPath,
    this.paths = const [],
    this.isAssetEmpty = false,
    this.totalAssetCount,
    this.currentAssets = const [],
  });

  final FormzSubmissionStatus status;
  final PathWrapper<AssetPathEntity>? currentPath;
  final List<PathWrapper<AssetPathEntity>> paths;
  final bool isAssetEmpty;
  final int? totalAssetCount;
  final List<AssetEntity> currentAssets;

  int get currentAssetsListPage =>
      (math.max(1, currentAssets.length) / pageSize).ceil();

  GalleryState copyWith({
    FormzSubmissionStatus? status,
    PathWrapper<AssetPathEntity>? currentPath,
    List<PathWrapper<AssetPathEntity>>? paths,
    bool? isAssetEmpty,
    int? totalAssetCount,
    List<AssetEntity>? currentAssets,
  }) {
    return GalleryState(
      status: status ?? this.status,
      currentPath: currentPath ?? this.currentPath,
      paths: paths ?? this.paths,
      isAssetEmpty: isAssetEmpty ?? this.isAssetEmpty,
      totalAssetCount: totalAssetCount ?? this.totalAssetCount,
      currentAssets: currentAssets ?? this.currentAssets,
    );
  }

  @override
  List<Object?> get props => [
    status,
    currentPath,
    paths,
    isAssetEmpty,
    totalAssetCount,
    currentAssets,
  ];
}
