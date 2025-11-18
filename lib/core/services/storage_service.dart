import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import '../error/failures.dart';

abstract class StorageService {
  Future<Either<Failure, String>> uploadImage({
    required Uint8List bytes,
    required String path,
  });

  Future<Either<Failure, Unit>> deleteImage(String path);
}

String generateStorageFilename(String originalName, {String? prefix}) {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final prefixStr = prefix != null ? '${prefix}_' : '';
  return '$prefixStr${timestamp}_$originalName';
}
