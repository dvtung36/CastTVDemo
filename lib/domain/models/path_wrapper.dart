import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class PathWrapper<Path> extends Equatable {
  const PathWrapper({
    required this.path,
    this.assetCount,
    this.thumbnailData,
  });

  final Path path;

  final int? assetCount;

  final Uint8List? thumbnailData;

  PathWrapper<Path> copyWith({
    int? assetCount,
    Uint8List? thumbnailData,
  }) {
    return PathWrapper(
      path: path,
      assetCount: assetCount ?? this.assetCount,
      thumbnailData: thumbnailData ?? this.thumbnailData,
    );
  }

  @override
  List<Object?> get props => [
    path,
    assetCount,
    thumbnailData,
  ];
}
