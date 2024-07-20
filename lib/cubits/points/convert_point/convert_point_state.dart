part of "convert_point_cubit.dart";

abstract class ConvertPointState {}

class ConvertPointInitial extends ConvertPointState {}

class ConvertPointLoading extends ConvertPointState {}

class ConvertPointDone extends ConvertPointState {
  final GeneralResponse response;
  ConvertPointDone({required this.response});
}

class ConvertPointError extends ConvertPointState {
  final String errorMessage;
  ConvertPointError({required this.errorMessage});
}
