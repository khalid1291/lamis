import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lamis/cubits/social_links/social_links_cubit.dart';
import 'package:lamis/models/general/social_links.dart';
import 'package:lamis/res/resources_export.dart';
import 'package:lamis/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../cubits/cubits.dart';

class SocialLinksScreen extends StatefulWidget {
  const SocialLinksScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SocialLinksScreen> createState() => _SocialLinksScreenState();
}

class _SocialLinksScreenState extends State<SocialLinksScreen> {
  FToast fToast = FToast();
  late SocialLinksCubit _socialLinksCubit;

  @override
  void initState() {
    fToast.init(context);
    _socialLinksCubit = SocialLinksCubit()..fetchSocialLinks();
    super.initState();
  }

  Future<bool> _willPopCallback() async {
    Navigator.pop(context, true);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
                child: BlocBuilder<SocialLinksCubit, SocialLinksState>(
              bloc: _socialLinksCubit,
              builder: (context, state) {
                if (state is SocialLinksLoading) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 1.7,
                          child: ListView.builder(
                              itemCount: 5,
                              itemBuilder: (BuildContext context, index) {
                                return DelayedAnimation(
                                    delay: index * 200,
                                    child: const ShimmerSocial());
                              })).customMargins(),
                    ],
                  );
                }
                if (state is SocialLinksDone) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 1.7,
                          child: ListView.builder(
                              itemCount:
                                  state.linksResponse.socialLinkData?.length,
                              itemBuilder: (BuildContext context, index) {
                                return DelayedAnimation(
                                  delay: index * 175,
                                  fromSide: FromSide.right,
                                  child: LinkWidget(
                                    linkData: state
                                        .linksResponse.socialLinkData![index],
                                  ),
                                );
                              })).customMargins(),
                    ],
                  );
                }
                if (state is SocialLinksError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomErrorWidget(onTap: () {
                        _socialLinksCubit.fetchSocialLinks();
                      }),
                    ),
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 1.7,
                          child: ListView.builder(
                              itemBuilder: (BuildContext context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                    width: 25,
                                    height: 25,
                                    imageUrl: "",
                                    fadeOutDuration: const Duration(seconds: 1),
                                    fadeInDuration: const Duration(seconds: 3),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(context
                                            .resources.images.errorImage),
                                    fit: BoxFit.cover,
                                  ),
                                  CustomText(
                                    content: "facebook",
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryTextColor,
                                    titletype: TitleType.bottoms,
                                  ),
                                  SizedBox(
                                    width: context
                                        .resources.dimension.priceContainer,
                                  )
                                ],
                              ),
                            );
                          })).customMargins(),
                    ],
                  );
                }
              },
            ))));
  }

  @override
  void dispose() {
    fToast.removeCustomToast();
    fToast.removeQueuedCustomToasts();
    super.dispose();
  }
}

class LinkWidget extends StatelessWidget {
  const LinkWidget({
    Key? key,
    required this.linkData,
  }) : super(key: key);

  final SocialLinkData linkData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        HapticFeedback.heavyImpact();

        var url = Uri.parse(linkData.link ?? '');
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              width: 30,
              height: 30,
              imageUrl: linkData.image ?? '',
              fadeOutDuration: const Duration(seconds: 1),
              fadeInDuration: const Duration(seconds: 3),
              errorWidget: (context, url, error) =>
                  Image.asset(context.resources.images.errorImage),
              fit: BoxFit.cover,
            ),
            CustomText(
              content: linkData.name ?? '',
              color: Theme.of(context).colorScheme.primaryTextColor,
              titletype: TitleType.bottoms,
            ),
            SizedBox(
              width: context.resources.dimension.priceContainer,
            )
          ],
        ),
      ),
    );
  }
}

class ShimmerSocial extends StatelessWidget {
  const ShimmerSocial({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            width: 30,
            height: 30,
            imageUrl: "",
            fadeOutDuration: const Duration(seconds: 1),
            fadeInDuration: const Duration(seconds: 3),
            errorWidget: (context, url, error) =>
                Image.asset(context.resources.images.errorImage),
            fit: BoxFit.cover,
          ),
          CustomText(
            content: "",
            color: Theme.of(context).colorScheme.primaryTextColor,
            titletype: TitleType.bottoms,
          ),
          SizedBox(
            width: context.resources.dimension.priceContainer,
          )
        ],
      ),
    );
  }
}
