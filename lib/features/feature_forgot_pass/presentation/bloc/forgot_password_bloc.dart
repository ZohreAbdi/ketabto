import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ketabto_test/features/feature_forgot_pass/domain/usecases/forgot_password_usecase.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordUseCase useCase;

  ForgotPasswordBloc(this.useCase)
      : super(ForgotPasswordInitial()) {

    on<ForgotPasswordRequested>((event, emit) async {

      emit(ForgotPasswordLoading());

      try {
        await useCase(event.email);

        emit(ForgotPasswordSuccess());

      } catch (e) {

        emit(ForgotPasswordFailure(e.toString()));

      }

    });
  }
}
