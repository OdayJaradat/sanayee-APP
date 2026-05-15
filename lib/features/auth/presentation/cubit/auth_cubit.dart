import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../profile/domain/entities/user_role.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_in_with_email.dart';
import '../../domain/usecases/sign_in_with_phone.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up_with_email.dart';
import '../../domain/usecases/verify_phone_otp.dart';
import 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final SignInWithEmail _signInWithEmail;
  final SignUpWithEmail _signUpWithEmail;
  final SignInWithPhone _signInWithPhone;
  final VerifyPhoneOtp _verifyPhoneOtp;
  final SignOut _signOut;
  final GetCurrentUser _getCurrentUser;

  AuthCubit(
    this._signInWithEmail,
    this._signUpWithEmail,
    this._signInWithPhone,
    this._verifyPhoneOtp,
    this._signOut,
    this._getCurrentUser,
  ) : super(const AuthState.initial());

  Future<void> checkAuthStatus() async {
    emit(const AuthState.loading());
    final result = await _getCurrentUser();
    result.fold(
      (failure) {
        if (failure is BlockedUserFailure) {
          emit(AuthState.blocked(failure.message));
        } else {
          emit(AuthState.unauthenticated(failure.message));
        }
      },
      (user) {
        if (user != null) {
          emit(AuthState.authenticated(user));
        } else {
          emit(const AuthState.unauthenticated(null));
        }
      },
    );
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    emit(const AuthState.loading());
    final result = await _signInWithEmail(email: email, password: password);
    result.fold(
      (failure) {
        if (failure is BlockedUserFailure) {
          emit(AuthState.blocked(failure.message));
        } else {
          emit(AuthState.error(failure.message));
        }
      },
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required UserRole role,
    String? fullName,
    String? phone,
    String? city,
    String? governorate,
    String? locality,
    DateTime? dateOfBirth,
    String? bio,
    String? avatarUrl,
    int yearsExperience = 0,
    List<String> certifications = const [],
    String? specialization,
  }) async {
    emit(const AuthState.loading());
    final result = await _signUpWithEmail(
      email: email,
      password: password,
      role: role,
      fullName: fullName,
      phone: phone,
      city: city,
      governorate: governorate,
      locality: locality,
      dateOfBirth: dateOfBirth,
      bio: bio,
      avatarUrl: avatarUrl,
      yearsExperience: yearsExperience,
      certifications: certifications,
      specialization: specialization,
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    emit(const AuthState.loading());
    final result = await _signInWithPhone(phoneNumber: phoneNumber);
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (verificationId) => emit(AuthState.phoneCodeSent(verificationId)),
    );
  }

  Future<void> verifyOtp({
    required String verificationId,
    required String otp,
    UserRole? role,
  }) async {
    emit(const AuthState.loading());
    final result = await _verifyPhoneOtp(
      verificationId: verificationId,
      otp: otp,
      role: role,
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> signOutUser() async {
    emit(const AuthState.loading());
    final result = await _signOut();
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.unauthenticated(null)),
    );
  }
}
