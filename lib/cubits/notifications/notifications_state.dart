part of 'notifications_cubit.dart';

abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsDone extends NotificationsState {
  final NotificationResponse? notificationResponse;
  final bool loading;

  NotificationsDone({this.notificationResponse, this.loading = false});
}

class NotificationsError extends NotificationsState {
  final String message;

  NotificationsError(this.message);
}
