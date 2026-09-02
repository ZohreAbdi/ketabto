import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ketabto_test/core/entities/user_entity.dart';
import 'package:ketabto_test/features/feature_email_verify/domain/usecases/email_verify_usecase.dart';
import 'package:ketabto_test/features/features_login/domain/entities/login_params.dart';
import 'package:ketabto_test/features/features_login/domain/usecases/login_usecase.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final ResendVerificationEmailUseCase resendUseCase;

  LoginBloc(this.loginUseCase,this.resendUseCase) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<ResendVerificationEmailEvent>(_onResendEmail);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      final user = await loginUseCase(
        LoginParams(email: event.email, password: event.password),
      );

      emit(LoginSuccess(user));
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');

      // 👇 اینجا نقطه کلیدی فیچر ماست
      if (message.toUpperCase().contains("EMAIL_NOT_VERIFIED")) {
        emit(EmailNotVerifiedState(event.email));
        return;
      }

      emit(LoginFailure(message));
    }
  }

  Future<void> _onResendEmail(
    ResendVerificationEmailEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      await resendUseCase(event.email);

      emit(ResendEmailSuccessState());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
