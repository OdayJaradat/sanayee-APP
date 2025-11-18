import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import '../../../auth/domain/usecases/get_current_user.dart';
import '../../../../app/env.dart';
import '../../../../app/injection.dart';
import '../../../requests/domain/entities/filter_criteria.dart';
import '../../../requests/domain/entities/service_request.dart';
import '../../../requests/domain/usecases/apply_filters_to_requests.dart';
import '../../../requests/domain/usecases/load_filters.dart';
import '../../../requests/domain/usecases/save_filters.dart';
import '../../../requests/domain/usecases/clear_filters.dart';
import '../../domain/entities/offer.dart';
import '../../domain/usecases/fetch_open_requests.dart';
import '../../domain/usecases/submit_offer.dart';

part 'pros_jobs_state.dart';

@injectable
class ProsJobsCubit extends Cubit<ProsJobsState> {
  final FetchOpenRequests _fetchOpenRequests;
  final SubmitOffer _submitOffer;
  final LoadFilters _loadFilters;
  final SaveFilters _saveFilters;
  final ClearFilters _clearFilters;
  final ApplyFiltersToRequests _applyFilters;

  FilterCriteria _currentCriteria = FilterCriteria.defaultCriteria();
  List<ServiceRequest> _allRequests = [];
  Position? _currentPosition;

  FilterCriteria get currentCriteria => _currentCriteria;

  ProsJobsCubit(
    this._fetchOpenRequests,
    this._submitOffer,
    this._loadFilters,
    this._saveFilters,
    this._clearFilters,
    this._applyFilters,
  ) : super(const ProsJobsState.initial()) {
    _initializeFilters();
  }

  Future<void> _initializeFilters() async {
    final result = await _loadFilters('pro');
    result.when(
      ok: (criteria) {
        _currentCriteria = criteria;
      },
      err: (_) {
        _currentCriteria = FilterCriteria.defaultCriteria();
      },
    );
  }

  Future<void> loadOpenRequests() async {
    emit(const ProsJobsState.loading());

    final result = await _fetchOpenRequests();

    result.when(
      ok: (requests) {
        _allRequests = requests;
        _applyCurrentFilters();
      },
      err: (failure) => emit(ProsJobsState.error(failure.message)),
    );
  }

  void _applyCurrentFilters() async {
    if (_currentCriteria.distanceKm != null && _currentPosition == null) {
      try {
        _currentPosition = await Geolocator.getCurrentPosition();
      } catch (e) {
        final _ = e;
      }
    }

    final filteredRequests = _applyFilters(
      _allRequests,
      _currentCriteria,
      currentPosition: _currentPosition,
    );

    emit(ProsJobsState.loaded(filteredRequests, _currentCriteria));
  }

  Future<void> applyFilters(FilterCriteria criteria) async {
    _currentCriteria = criteria;

    await _saveFilters('pro', criteria);

    if (criteria.distanceKm == null) {
      _currentPosition = null;
    }

    _applyCurrentFilters();
  }

  Future<void> clearAllFilters() async {
    _currentCriteria = FilterCriteria.defaultCriteria();
    _currentPosition = null;

    await _clearFilters('pro');

    _applyCurrentFilters();
  }

  Future<void> submitOffer({
    required String requestId,
    required double amount,
    String? note,
    String? professionalId,
  }) async {
    final userResult = await sl<GetCurrentUser>()();
    String? failureMessage;
    final user = userResult.fold((failure) {
      failureMessage = failure.message;
      return null;
    }, (user) => user);

    late final String resolvedProfessionalId;

    if (Env.useAuth) {
      if (user == null) {
        emit(
          ProsJobsState.error(
            failureMessage ??
                'Authentication required. Please sign in as a professional.',
          ),
        );
        return;
      }

      if (!user.role.isProfessional) {
        emit(
          const ProsJobsState.error(
            'Only professional accounts can submit offers.',
          ),
        );
        return;
      }

      if (professionalId != null && professionalId != user.id) {
        emit(
          const ProsJobsState.error(
            'You can only submit offers with your own professional account.',
          ),
        );
        return;
      }

      resolvedProfessionalId = user.id;
    } else {
      resolvedProfessionalId = professionalId ?? user?.id ?? 'pro-1';
    }

    
    final currentState = state;
    List<ServiceRequest> currentRequests = _allRequests;
    FilterCriteria currentCriteria = _currentCriteria;

    if (currentState is _Loaded) {
      currentRequests = currentState.requests;
      currentCriteria = currentState.filterCriteria;
    }

    emit(ProsJobsState.submitting(currentRequests, currentCriteria));

    final result = await _submitOffer(
      requestId: requestId,
      professionalId: resolvedProfessionalId,
      amount: amount,
      note: note,
    );

    result.when(
      ok: (offer) => emit(ProsJobsState.offerSubmitted(offer)),
      err: (failure) => emit(ProsJobsState.error(failure.message)),
    );
  }

  void resetToLoaded(List<ServiceRequest> requests) {
    emit(ProsJobsState.loaded(requests));
  }
}
