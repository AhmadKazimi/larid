import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class LoginEvent extends AuthEvent {
  final UserEntity userEntity;

  const LoginEvent({required this.userEntity});

  @override
  List<Object?> get props => [userEntity];
}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SharedPreferences _prefs;

  AuthBloc({
    required this.loginUseCase,
    required SharedPreferences prefs,
  })  : _prefs = prefs,
        super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(const AuthLoading());
      try {
        final isAuthenticated = await loginUseCase(event.userEntity);
        if (isAuthenticated) {
          await _prefs.setBool('is_logged_in', true);
          emit(const AuthAuthenticated());
        } else {
          emit(const AuthError('Invalid credentials'));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
