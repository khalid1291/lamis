part of 'delete_image_cubit.dart';

abstract class RemoveImageState {}

class RemoveImageInitial extends RemoveImageState {}

class RemoveImageLoading extends RemoveImageState {}

class RemoveImageDone extends RemoveImageState {
  final GeneralResponse response;

  RemoveImageDone({required this.response});
}

class RemoveImageError extends RemoveImageState {
  final String errorMessage;
  RemoveImageError({required this.errorMessage});
}
