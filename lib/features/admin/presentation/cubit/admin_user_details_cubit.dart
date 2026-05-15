import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_user_details.dart';
import '../../domain/repositories/admin_repository.dart';

part 'admin_user_details_state.dart';

/// Note: Uses manual DI via AdminInjection (not Injectable)
class AdminUserDetailsCubit extends Cubit<AdminUserDetailsState> {
  final AdminRepository _repository;

  AdminUserDetailsCubit(this._repository) : super(const AdminUserDetailsState.initial());

  Future<void> load(String userId) async {
    emit(const AdminUserDetailsState.loading());

    final result = await _repository.getUserDetails(userId);

    result.when(
      ok: (details) => emit(AdminUserDetailsState.loaded(details)),
      err: (failure) => emit(AdminUserDetailsState.error(failure.message)),
    );
  }

  Future<void> refresh(String userId) async {
    await load(userId);
  }
}
