part of 'social_links_cubit.dart';

abstract class SocialLinksState {}

class SocialLinksInitial extends SocialLinksState {}

class SocialLinksLoading extends SocialLinksState {}

class SocialLinksDone extends SocialLinksState {
  final SocialLinksResponse linksResponse;

  SocialLinksDone(this.linksResponse);
}

class SocialLinksError extends SocialLinksState {
  final String message;

  SocialLinksError(this.message);
}
