import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/service_request.dart';
import '../../domain/repositories/requests_repository.dart';
import '../../../auth/domain/usecases/get_current_user.dart';
import '../../domain/usecases/close_request.dart';

part 'requests_state.dart';

@injectable
class RequestsCubit extends Cubit<RequestsState> {
  final RequestsRepository _repository;
  final GetCurrentUser _getCurrentUser;
  final CloseRequest _closeRequest;

  RequestsCubit(this._repository, this._getCurrentUser, this._closeRequest)
    : super(const RequestsState.initial());

  Future<void> loadRequests() async {
    emit(const RequestsState.loading());

    final userResult = await _getCurrentUser();

    userResult.fold((failure) => emit(RequestsState.error(failure.message)), (
      user,
    ) async {
      if (user == null) {
        emit(const RequestsState.error('المستخدم غير مسجل دخول'));
        return;
      }

      final result = await _repository.fetchRequests(clientId: user.id);

      result.when(
        ok: (requests) => emit(RequestsState.loaded(requests)),
        err: (failure) => emit(RequestsState.error(failure.message)),
      );
    });
  }

  Future<void> refreshRequests() async {
    await loadRequests();
  }

  Future<void> deleteRequest(String requestId) async {
    try {
      final result = await _repository.deleteById(requestId);

      result.when(
        ok: (_) {
          loadRequests();
        },
        err: (failure) {
          if (!isClosed) {
            emit(RequestsState.error('فشل حذف الطلب: ${failure.message}'));
          }
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(RequestsState.error('فشل حذف الطلب: ${e.toString()}'));
      }
    }
  }

  Future<void> closeRequest(String requestId) async {
    try {
      final userResult = await _getCurrentUser();

      await userResult.fold(
        (failure) async {
          if (!isClosed) {
            emit(RequestsState.error(failure.message));
          }
        },
        (user) async {
          if (user == null) {
            if (!isClosed) {
              emit(const RequestsState.error('المستخدم غير مسجل دخول'));
            }
            return;
          }

          final result = await _closeRequest(
            requestId: requestId,
            clientId: user.id,
          );

          result.when(
            ok: (_) {
              loadRequests();
            },
            err: (failure) {
              if (!isClosed) {
                emit(
                  RequestsState.error('فشل إغلاق الطلب: ${failure.message}'),
                );
              }
            },
          );
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(RequestsState.error('فشل إغلاق الطلب: ${e.toString()}'));
      }
    }
  }

  List<ServiceRequest> getActiveRequests(List<ServiceRequest> allRequests) {
    return allRequests
        .where((r) => r.status != 'completed' && r.status != 'closed')
        .toList();
  }

  List<ServiceRequest> getCompletedRequests(List<ServiceRequest> allRequests) {
    return allRequests.where((r) => r.status == 'completed').toList();
  }

  List<ServiceRequest> getClosedRequests(List<ServiceRequest> allRequests) {
    return allRequests.where((r) => r.status == 'closed').toList();
  }
}
