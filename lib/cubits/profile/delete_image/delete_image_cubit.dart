import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../../../models/models.dart';
import '../../../../repos/repos.dart';
import '../../../main.dart';

part 'delete_image_state.dart';

class RemoveImageCubit extends Cubit<RemoveImageState> {
  RemoveImageCubit() : super(RemoveImageInitial());

  void removeProfileImage() async {
    UserRepo repo = UserRepo();

    emit(RemoveImageLoading());

    try {
      GeneralResponse response = await repo.removeProfileImage();

      if (response.result) {
        emit(RemoveImageDone(response: response));
      } else {
        emit(RemoveImageError(errorMessage: response.message));
      }
    } catch (e) {
      emit(RemoveImageError(
          errorMessage: (MyApp.context.resources.strings.errorGot)));
    }
  }
}
