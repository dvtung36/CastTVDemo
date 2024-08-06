import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  FileUtils._();

  static final FileUtils _shared = FileUtils._();

  factory FileUtils() => _shared;

  Future<Directory> createDirectory(
    String directoryPath, {
    bool recursive = false,
  }) {
    return Directory(directoryPath).create(recursive: recursive);
  }

  String getFileName(String path) {
    return basename(path);
  }

  String getFileExtension(String path) {
    return extension(path);
  }

  Future<String> getAppDirPath() async {
    return (await getApplicationDocumentsDirectory()).absolute.path;
  }

  Future<String> getTemporaryDirPath() async {
    return (await getTemporaryDirectory()).absolute.path;
  }
}
