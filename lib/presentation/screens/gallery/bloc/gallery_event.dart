part of 'gallery_bloc.dart';

sealed class GalleryEvent extends Equatable {
  const GalleryEvent();

  @override
  List<Object?> get props => [];
}

class GalleryGetPaths extends GalleryEvent {
  const GalleryGetPaths();
}

class GalleryGetAssets extends GalleryEvent {
  const GalleryGetAssets();
}

class GalleryGetAssetsWithPage extends GalleryEvent {
  const GalleryGetAssetsWithPage(this.page, this.assetPath);

  final int? page;
  final AssetPathEntity? assetPath;

  @override
  List<Object?> get props => [page, assetPath];
}

class GalleryPathSelected extends GalleryEvent {
  const GalleryPathSelected(this.path);

  final PathWrapper<AssetPathEntity>? path;

  @override
  List<Object?> get props => [path];
}
