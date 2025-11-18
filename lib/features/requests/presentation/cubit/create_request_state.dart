part of 'create_request_cubit.dart';

@freezed
class CreateRequestState with _$CreateRequestState {
  const factory CreateRequestState.initial() = _Initial;
  const factory CreateRequestState.loading() = _Loading;
  const factory CreateRequestState.success() = _Success;
  const factory CreateRequestState.error(String message) = _Error;
}
