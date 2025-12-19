import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice13/core/models/user_profile_model.dart';
import 'package:flutter_practice13/domain/usecases/profile/get_profile_usecase.dart';
import 'package:flutter_practice13/domain/usecases/profile/update_profile_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(const ProfileState());

  Future<void> loadProfile() async {
    try {
      final profile = await getProfileUseCase();
      emit(state.copyWith(profile: profile));
    } catch (e) {
      emit(state.copyWith(profile: null));
    }
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? drivingLicenseNumber,
    int? drivingExperienceYears,
  }) async {
    if (state.profile == null) return;

    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 500));

    final updatedProfile = state.profile!.copyWith(
      name: name,
      phone: phone,
      drivingLicenseNumber: drivingLicenseNumber,
      drivingExperienceYears: drivingExperienceYears,
    );

    try {
      await updateProfileUseCase(updatedProfile);
      emit(state.copyWith(
        profile: updatedProfile,
        isLoading: false,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        clearError: false,
      ));
    }
  }

  void clearProfile() {
    emit(const ProfileState());
  }
}
