import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/models/general/notification_response.dart';
import 'package:lamis/repos/app/app_repo.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../main.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  AppRepo appRepo = AppRepo();
  NotificationsCubit() : super(NotificationsInitial());

  void getNotifications({int pageNumber = 1}) async {
    if (pageNumber == 1) {
      emit(NotificationsLoading());
    } else {
      emit(NotificationsDone(loading: true));
    }

    try {
      var response = await appRepo.getUserNotifications(page: pageNumber);

      emit(NotificationsDone(notificationResponse: response, loading: false));
    } on Exception {
      emit(NotificationsError(MyApp.context.resources.strings.errorGot));
    }
  }
}
