import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/service_request.dart';
import '../../domain/usecases/get_request_by_id.dart';
import '../../domain/usecases/delete_request.dart';
import '../../domain/usecases/mark_request_completed.dart';
import '../../domain/usecases/confirm_job_completion.dart';
import '../../domain/usecases/reject_job_completion.dart';
import '../../domain/usecases/close_request.dart';
import '../../../professionals/domain/entities/offer.dart';
import '../../../professionals/domain/usecases/list_offers.dart';
import '../../../professionals/domain/usecases/accept_offer.dart';
import '../../../professionals/domain/usecases/decline_offer.dart';
import '../../../professionals/domain/usecases/counter_offer.dart';

part 'request_details_state.dart';

@injectable
class RequestDetailsCubit extends Cubit<RequestDetailsState> {
  final GetRequestById _getRequestById;
  final DeleteRequest _deleteRequest;
  final ListOffers _listOffers;
  final AcceptOffer _acceptOffer;
  final DeclineOffer _declineOffer;
  final CounterOffer _counterOffer;
  final MarkRequestCompleted _markRequestCompleted;
  final ConfirmJobCompletion _confirmJobCompletion;
  final RejectJobCompletion _rejectJobCompletion;
  final CloseRequest _closeRequest;

  ServiceRequest? _currentRequest;
  List<Offer> _currentOffers = [];

  RequestDetailsCubit(
    this._getRequestById,
    this._deleteRequest,
    this._listOffers,
    this._acceptOffer,
    this._declineOffer,
    this._counterOffer,
    this._markRequestCompleted,
    this._confirmJobCompletion,
    this._rejectJobCompletion,
    this._closeRequest,
  ) : super(const RequestDetailsState.initial());

  Future<void> loadRequest(String id) async {
    emit(const RequestDetailsState.loading());

    final result = await _getRequestById(id);

    if (isClosed) return;

    result.when(
      ok: (request) async {
        _currentRequest = request;
        await _loadOffers(request.id);
      },
      err: (failure) {
        if (!isClosed) {
          emit(RequestDetailsState.error(failure.message));
        }
      },
    );
  }

  Future<void> _loadOffers(String requestId) async {
    final offersResult = await _listOffers(requestId);

    if (isClosed) return;

    offersResult.when(
      ok: (offers) {
        _currentOffers = offers;
        if (_currentRequest != null && !isClosed) {
          emit(RequestDetailsState.loaded(_currentRequest!, _currentOffers));
        }
      },
      err: (failure) {
        if (_currentRequest != null && !isClosed) {
          emit(RequestDetailsState.loaded(_currentRequest!, []));
        }
      },
    );
  }

  Future<void> acceptOfferAction(
    String offerId,
    String requestId,
    String clientId,
  ) async {
    if (_currentRequest != null) {
      emit(
        RequestDetailsState.offerActionInProgress(
          _currentRequest!,
          _currentOffers,
        ),
      );
    }

    final result = await _acceptOffer(offerId, requestId, clientId);

    result.when(
      ok: (acceptOfferResult) async {
        emit(
          RequestDetailsState.offerAccepted(
            'تم قبول العرض',
            acceptOfferResult.conversationId,
          ),
        );
        await loadRequest(requestId);
      },
      err: (failure) {
        emit(RequestDetailsState.error(failure.message));
      },
    );
  }

  Future<void> declineOfferAction(String offerId, String requestId) async {
    if (_currentRequest != null) {
      emit(
        RequestDetailsState.offerActionInProgress(
          _currentRequest!,
          _currentOffers,
        ),
      );
    }

    final result = await _declineOffer(offerId);

    result.when(
      ok: (offer) async {
        emit(const RequestDetailsState.offerActionSuccess('تم رفض العرض'));
        await loadRequest(requestId);
      },
      err: (failure) {
        emit(RequestDetailsState.error(failure.message));
      },
    );
  }

  Future<void> counterOfferAction({
    required String offerId,
    required String requestId,
    required double newAmount,
    String? note,
  }) async {
    if (_currentRequest != null) {
      emit(
        RequestDetailsState.offerActionInProgress(
          _currentRequest!,
          _currentOffers,
        ),
      );
    }

    final result = await _counterOffer(
      offerId: offerId,
      newAmount: newAmount,
      note: note,
    );

    result.when(
      ok: (offer) async {
        emit(const RequestDetailsState.offerActionSuccess('تم إرسال عرض مضاد'));
        await loadRequest(requestId);
      },
      err: (failure) {
        emit(RequestDetailsState.error(failure.message));
      },
    );
  }

  Future<void> deleteRequest(String id) async {
    emit(const RequestDetailsState.deleting());

    final result = await _deleteRequest(id);

    result.when(
      ok: (_) => emit(const RequestDetailsState.deleted()),
      err: (failure) => emit(RequestDetailsState.error(failure.message)),
    );
  }

  Future<void> markCompleted(String requestId, String professionalId) async {
    if (_currentRequest != null) {
      emit(
        RequestDetailsState.offerActionInProgress(
          _currentRequest!,
          _currentOffers,
        ),
      );
    }

    final result = await _markRequestCompleted(
      requestId: requestId,
      professionalId: professionalId,
    );

    result.when(
      ok: (request) async {
        emit(
          const RequestDetailsState.offerActionSuccess('تم إكمال الطلب بنجاح'),
        );
        await loadRequest(requestId);
      },
      err: (failure) {
        emit(RequestDetailsState.error(failure.message));
      },
    );
  }

  Future<void> confirmCompletion(String requestId, String clientId) async {
    if (_currentRequest != null) {
      emit(
        RequestDetailsState.offerActionInProgress(
          _currentRequest!,
          _currentOffers,
        ),
      );
    }

    final result = await _confirmJobCompletion(
      requestId: requestId,
      clientId: clientId,
    );

    result.when(
      ok: (request) async {
        final professionalId = request.assignedProfessionalId ?? '';
        emit(
          RequestDetailsState.completionConfirmed(
            'تم تأكيد الإنجاز بنجاح',
            professionalId,
          ),
        );
        await loadRequest(requestId);
      },
      err: (failure) {
        emit(RequestDetailsState.error(failure.message));
      },
    );
  }

  Future<void> rejectCompletion(
    String requestId,
    String clientId, {
    String? reason,
  }) async {
    if (_currentRequest != null) {
      emit(
        RequestDetailsState.offerActionInProgress(
          _currentRequest!,
          _currentOffers,
        ),
      );
    }

    final result = await _rejectJobCompletion(
      requestId: requestId,
      clientId: clientId,
      reason: reason,
    );

    result.when(
      ok: (request) async {
        emit(
          const RequestDetailsState.offerActionSuccess(
            'تم رفض الإنجاز. سيتم إعادة التواصل مع الصنايعي',
          ),
        );
        await loadRequest(requestId);
      },
      err: (failure) {
        emit(RequestDetailsState.error(failure.message));
      },
    );
  }

  Future<void> closeRequestAction(String requestId, String clientId) async {
    if (_currentRequest != null) {
      emit(
        RequestDetailsState.offerActionInProgress(
          _currentRequest!,
          _currentOffers,
        ),
      );
    }

    final result = await _closeRequest(
      requestId: requestId,
      clientId: clientId,
    );

    result.when(
      ok: (request) async {
        emit(const RequestDetailsState.offerActionSuccess('تم إغلاق الطلب'));
        await loadRequest(requestId);
      },
      err: (failure) {
        emit(RequestDetailsState.error(failure.message));
      },
    );
  }
}
