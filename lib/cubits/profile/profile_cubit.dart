import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repos/repos.dart';
import '../../../../models/models.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  void getProfileData() async {
    UserRepo repo = UserRepo();

    emit(ProfileLoading());

    try {
      ProfileResponse response = await repo.getProfileResponse();

      if (response.result) {
        emit(ProfileDone(profileResponse: response));
      } else {
        emit(ProfileError());
      }
    } catch (e) {
      emit(ProfileError());
    }
  }
}
