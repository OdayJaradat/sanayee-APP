part of 'quick_request_cubit.dart';

sealed class QuickRequestState {
  const QuickRequestState();
}

class QuickRequestInitial extends QuickRequestState {
  const QuickRequestInitial();
}

class QuickRequestLoading extends QuickRequestState {
  const QuickRequestLoading();
}

class QuickRequestSuccess extends QuickRequestState {
  final String conversationId;
  final String professionalName;

  const QuickRequestSuccess({
    required this.conversationId,
    required this.professionalName,
  });
}

class QuickRequestError extends QuickRequestState {
  final String message;

  const QuickRequestError(this.message);
}
