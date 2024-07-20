import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/models/general/social_links.dart';
import 'package:lamis/repos/app/app_repo.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../main.dart';

part 'social_links_state.dart';

class SocialLinksCubit extends Cubit<SocialLinksState> {
  final AppRepo _myRepo = AppRepo();
  SocialLinksCubit() : super(SocialLinksInitial());

  Future<void> fetchSocialLinks() async {
    emit(SocialLinksLoading());
    try {
      _myRepo.getSocialLinks().then((value) {
        emit(SocialLinksDone(value));
      }).onError((error, stackTrace) {
        emit(SocialLinksError(MyApp.context.resources.strings.errorGot));
      });
    } catch (e) {
      emit(SocialLinksError(MyApp.context.resources.strings.errorGot));
    }
  }
}
