import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import '../../../../app/env.dart';
import '../../../../core/services/storage_service.dart';
import '../../../auth/domain/usecases/get_current_user.dart';
import '../../domain/usecases/create_request.dart';

part 'create_request_state.dart';
part 'create_request_cubit.freezed.dart';

@injectable
class CreateRequestCubit extends Cubit<CreateRequestState> {
  final CreateRequest _createRequest;
  final GetCurrentUser _getCurrentUser;
  final StorageService _storageService;

  CreateRequestCubit(
    this._createRequest,
    this._getCurrentUser,
    this._storageService,
  ) : super(const CreateRequestState.initial());

  Future<void> createRequest({
    required String title,
    required String description,
    required String category,
    double? budget,
    String? location,
    List<XFile>? photoFiles,
  }) async {
    emit(const CreateRequestState.loading());

    final userResult = await _getCurrentUser();
    String? failureMessage;
    final user = userResult.fold((failure) {
      failureMessage = failure.message;
      return null;
    }, (user) => user);

    late final String clientId;

    if (Env.useAuth) {
      if (user == null) {
        emit(
          CreateRequestState.error(
            failureMessage ??
                'Authentication required. Please sign in as a client.',
          ),
        );
        return;
      }

      if (!user.role.isClient) {
        emit(
          const CreateRequestState.error(
            'Only client accounts can create service requests.',
          ),
        );
        return;
      }

      clientId = user.id;
    } else {
      clientId = user?.id ?? 'client-1';
    }

    List<String>? photoUrls;
    if (photoFiles != null && photoFiles.isNotEmpty) {
      photoUrls = [];
      for (var i = 0; i < photoFiles.length; i++) {
        final file = photoFiles[i];
        final bytes = await file.readAsBytes();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final path = 'requests/$clientId/${timestamp}_$i.jpg';

        final uploadResult = await _storageService.uploadImage(
          bytes: bytes,
          path: path,
        );

        uploadResult.fold(
          (failure) {
          },
          (url) {
            photoUrls!.add(url);
          },
        );
      }
    }

    final result = await _createRequest(
      title: title,
      description: description,
      category: category,
      clientId: clientId,
      budget: budget,
      location: location,
      photos: photoUrls,
    );

    result.when(
      ok: (_) => emit(const CreateRequestState.success()),
      err: (failure) => emit(CreateRequestState.error(failure.message)),
    );
  }
}
