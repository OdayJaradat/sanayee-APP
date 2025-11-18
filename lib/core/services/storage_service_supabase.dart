import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../error/failures.dart';
import 'storage_service.dart';

@LazySingleton(as: StorageService, env: [Environment.prod])
class StorageServiceSupabase implements StorageService {
  final SupabaseClient _supabase;
  static const String _bucketName = 'media';

  StorageServiceSupabase(this._supabase);

  @override
  Future<Either<Failure, String>> uploadImage({
    required Uint8List bytes,
    required String path,
  }) async {
    try {
      await _supabase.storage
          .from(_bucketName)
          .uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      final publicUrl = _supabase.storage.from(_bucketName).getPublicUrl(path);

      return Right(publicUrl);
    } on StorageException catch (e) {
      return Left(ServerFailure('فشل رفع الصورة: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ أثناء رفع الصورة'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteImage(String path) async {
    try {
      await _supabase.storage.from(_bucketName).remove([path]);
      return const Right(unit);
    } on StorageException catch (e) {
      return Left(ServerFailure('فشل حذف الصورة: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ أثناء حذف الصورة'));
    }
  }
}
