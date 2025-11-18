import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/professional_stats_model.dart';
import '../../domain/entities/professional.dart';
import '../../domain/repositories/professionals_repository.dart';
import '../../domain/usecases/get_professional_by_id.dart';

part 'pro_profile_state.dart';

@injectable
class ProProfileCubit extends Cubit<ProProfileState> {
  final GetProfessionalById _getProfessionalById;
  final ProfessionalsRepository _professionalsRepository;

  ProProfileCubit(this._getProfessionalById, this._professionalsRepository)
    : super(const ProProfileState.initial());

  ProfessionalStatsModel? _cachedStats;

  Future<void> loadProfessional(String id) async {
    emit(const ProProfileState.loading());

    final result = await _getProfessionalById(id);

    result.when(
      ok: (professional) => emit(ProProfileState.loaded(professional)),
      err: (failure) => emit(ProProfileState.error(failure.message)),
    );

    await _fetchStats(id);
  }

  
  Future<void> refreshStats(String professionalId) async {
    await _fetchStats(professionalId);
  }

  Future<void> _fetchStats(String professionalId) async {
    final result = await _professionalsRepository.fetchProfessionalStats(
      professionalId,
    );
    result.when(
      ok: (stats) {
        _cachedStats = stats;
        
        final currentState = state;
        if (currentState is _Loaded) {
          emit(ProProfileState.loaded(currentState.professional));
        }
      },
      err: (_) {
      },
    );
  }

  ProfessionalStatsModel? get cachedStats => _cachedStats;
}
