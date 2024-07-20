import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../../../repos/repos.dart';
import '../../../../models/models.dart';
import '../../../main.dart';

part 'profile_edit_state.dart';

class ProfileEditCubit extends Cubit<ProfileEditState> {
  ProfileEditCubit() : super(ProfileEditInitial());

  void editProfileData(
      {required int id, required String name, required String email}) async {
    UserRepo repo = UserRepo();

    emit(ProfileEditLoading());

    try {
      ProfileEditResponse response =
          await repo.editProfile(id: id, name: name, email: email);

      if (response.result) {
        emit(ProfileEditDone(profileEditResponse: response));
      } else {
        emit(ProfileEditError(errorMessage: response.message));
      }
    } catch (e) {
      emit(ProfileEditError(
          errorMessage: (MyApp.context.resources.strings.errorGot)));
    }
  }

  void editProfileImage(
      {required int id,
      required String fileName,
      required String image}) async {
    UserRepo repo = UserRepo();

    emit(ProfileEditLoading());

    try {
      ProfileUploadImageResponse response =
          await repo.editProfileImage(id: id, fileName: fileName, image: image);

      if (response.result) {
        emit(UploadImageDone(profileUploadImageResponse: response));
      } else {
        emit(ProfileEditError(errorMessage: response.message));
      }
    } catch (e) {
      emit(ProfileEditError(
          errorMessage: (MyApp.context.resources.strings.errorGot)));
    }
  }
}
