part of 'profile_edit_cubit.dart';

abstract class ProfileEditState {}

class ProfileEditInitial extends ProfileEditState {}

class ProfileEditLoading extends ProfileEditState {}

class ProfileEditDone extends ProfileEditState {
  final ProfileEditResponse profileEditResponse;

  ProfileEditDone({required this.profileEditResponse});
}

class UploadImageDone extends ProfileEditState {
  final ProfileUploadImageResponse profileUploadImageResponse;

  UploadImageDone({required this.profileUploadImageResponse});
}

class ProfileEditError extends ProfileEditState {
  final String errorMessage;
  ProfileEditError({required this.errorMessage});
}
