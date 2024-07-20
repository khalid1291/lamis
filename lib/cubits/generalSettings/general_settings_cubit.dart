import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/models/general/general_settings.dart';
import 'package:lamis/repos/repos.dart';

part 'general_settings_state.dart';

class GeneralSettingsCubit extends Cubit<GeneralSettingsState> {
  AppRepo appRepo = AppRepo();
  List<String> countries = [];
  GeneralSettingsCubit() : super(GeneralSettingsInitial());

  Future<void> getGeneralSettings() async {
    emit(GeneralSettingsLoading());

    try {
      GeneralSettings generalSettings = await appRepo.getGeneralSettings();
      for (var element in generalSettings.countries!.data!) {
        countries.add(element.code ?? "");
      }
      emit(GeneralSettingsDone(generalSettings));
    } catch (e) {
      emit(GeneralSettingsError(e.toString()));
    }
  }
}
