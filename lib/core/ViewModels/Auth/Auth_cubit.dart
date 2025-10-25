import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_hub/core/Repository/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handy_hub/core/ViewModels/Auth/Auth_state.dart';


class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial()) {
    _authRepository.user.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.loginWithEmail(email, password);
      if (user != null) {
        emit(AuthAuthenticated(user!));
      } else {
        emit(AuthError("الحساب غير موجود"));
      }}
    on FirebaseAuthException catch (e) {
      emit(AuthError(e.code)); // نرسل الكود فقط

    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  loginByGmail(){
    _authRepository.loginByGmail();
  }

  Future<void> signUp(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signUpWithEmailPassword(email, password);
      emit(AuthAuthenticated(user!));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    emit(AuthUnauthenticated());
  }
}