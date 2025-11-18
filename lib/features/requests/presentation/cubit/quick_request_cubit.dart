import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_current_position.dart';
import '../../domain/usecases/find_nearest_professional.dart';
import '../../domain/usecases/create_quick_request.dart';
import '../../../auth/domain/usecases/get_current_user.dart';

part 'quick_request_state.dart';

@injectable
class QuickRequestCubit extends Cubit<QuickRequestState> {
  final GetCurrentPosition _getCurrentPosition;
  final FindNearestProfessional _findNearestProfessional;
  final CreateQuickRequest _createQuickRequest;
  final GetCurrentUser _getCurrentUser;

  QuickRequestCubit(
    this._getCurrentPosition,
    this._findNearestProfessional,
    this._createQuickRequest,
    this._getCurrentUser,
  ) : super(const QuickRequestInitial());

  
  Future<void> submitQuickRequest() async {
    emit(const QuickRequestLoading());

    final positionResult = await _getCurrentPosition();

    await positionResult.when(
      ok: (location) async {
        final professionalResult = await _findNearestProfessional(
          latitude: location.latitude,
          longitude: location.longitude,
        );

        await professionalResult.when(
          ok: (professional) async {
            final userResult = await _getCurrentUser();

            await userResult.fold(
              (failure) async {
                emit(QuickRequestError(failure.message));
              },
              (user) async {
                if (user == null) {
                  emit(const QuickRequestError('المستخدم غير مسجل دخول'));
                  return;
                }

                final createResult = await _createQuickRequest
                    .createWithConversation(
                      clientId: user.id,
                      professional: professional,
                      clientLocation: location.toMap(),
                    );

                createResult.when(
                  ok: (result) {
                    emit(
                      QuickRequestSuccess(
                        conversationId: result.conversationId,
                        professionalName: result.professional.name,
                      ),
                    );
                  },
                  err: (failure) {
                    emit(QuickRequestError(failure.message));
                  },
                );
              },
            );
          },
          err: (failure) {
            emit(QuickRequestError(failure.message));
          },
        );
      },
      err: (failure) {
        emit(QuickRequestError(failure.message));
      },
    );
  }

  
  Future<bool> checkPermission() async {
    return await _getCurrentPosition.hasPermission();
  }

  
  Future<bool> openLocationSettings() async {
    return await _getCurrentPosition.openLocationSettings();
  }

  
  Future<bool> openAppSettings() async {
    return await _getCurrentPosition.openAppSettings();
  }
}
