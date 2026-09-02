import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ketabto_test/core/entities/user_entity.dart';
import 'package:ketabto_test/core/models/user_model.dart';
import 'package:ketabto_test/features/feature_profile/domain/usecases/profile_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;

  ProfileBloc(this.getProfileUseCase)
      : super(ProfileInitial()) {
    on<GetProfileEvent>(_getProfile);
  }

  Future<void> _getProfile(
    GetProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final user = await getProfileUseCase();

      emit(ProfileSuccess (user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
