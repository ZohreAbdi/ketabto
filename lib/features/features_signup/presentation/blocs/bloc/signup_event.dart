part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent extends Equatable {
  const SignupEvent();
  @override
  List<Object?> get props => [];
}

class SignupSubmitted extends SignupEvent {
  final String name;
  final String phoneNumber;
  final String email;
  final String password;

  const SignupSubmitted({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, phoneNumber, email, password];
}
