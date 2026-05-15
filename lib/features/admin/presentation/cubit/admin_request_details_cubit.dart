import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_request_details.dart';
import '../../domain/repositories/admin_repository.dart';

part 'admin_request_details_state.dart';

/// Note: Uses manual DI via AdminInjection (not Injectable)
class AdminRequestDetailsCubit extends Cubit<AdminRequestDetailsState> {
  final AdminRepository _repository;

  AdminRequestDetailsCubit(this._repository) : super(const AdminRequestDetailsState.initial());

  Future<void> load(String requestId) async {
    emit(const AdminRequestDetailsState.loading());

    final result = await _repository.getRequestDetails(requestId);

    result.when(
      ok: (details) {
        if (details == null) {
          emit(const AdminRequestDetailsState.error(
            'الطلب غير موجود أو ليس لديك صلاحية للوصول إليه',
          ));
        } else {
          emit(AdminRequestDetailsState.loaded(details));
        }
      },
      err: (failure) => emit(AdminRequestDetailsState.error(failure.message)),
    );
  }

  Future<void> refresh(String requestId) async {
    await load(requestId);
  }
}
