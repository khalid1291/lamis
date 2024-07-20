part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileDone extends ProfileState {
  final ProfileResponse profileResponse;

  ProfileDone({required this.profileResponse});
}

class ProfileError extends ProfileState {}
