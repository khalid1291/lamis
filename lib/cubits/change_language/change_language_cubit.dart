import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/models/general/general_response.dart';

import '../../repos/app/app_repo.dart';

part 'change_language_state.dart';

class ChangeLanguageCubit extends Cubit<ChangeLanguageState> {
  AppRepo appRepo = AppRepo();
  ChangeLanguageCubit() : super(ChangeLanguageInitial());

  Future<void> changeLang(String lang) async {
    emit(ChangeLanguageLoading());
    try {
      await appRepo
          .changelang(lang)
          .then((value) => emit(ChangeLanguageDone(value)))
          .onError((error, stackTrace) {
        emit(ChangeLanguageError());
      });
    } catch (e) {
      emit(ChangeLanguageError());
    }
  }
}
