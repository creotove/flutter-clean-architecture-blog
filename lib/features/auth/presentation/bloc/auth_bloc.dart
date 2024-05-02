import 'package:clean_architecture_blog_app/features/auth/domain/useCases/user_sign_in.dart';
import 'package:clean_architecture_blog_app/features/auth/domain/useCases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
  })  : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        super(AuthInitial()) {
    on<AuthSignUp>((event, emit) async {
      final res = await _userSignUp(UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ));
      res.fold(
        (failure) => emit(AuthFailure(message: failure.message)),
        (uid) => emit(AuthSuccess(uid)),
      );
    });
    on<AuthSignIn>((event, emit) async {
      final res = await _userSignIn(UserSignInParams(
        email: event.email,
        password: event.password,
      ));
      res.fold(
        (failure) => emit(AuthFailure(message: failure.message)),
        (res) => emit(AuthSuccess(res)),
      );
    });
  }
}
