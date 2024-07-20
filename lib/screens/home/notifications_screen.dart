import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/cubits/cubits.dart';
import 'package:lamis/cubits/notifications/notifications_cubit.dart';
import 'package:lamis/models/general/notification_response.dart';
import 'package:lamis/res/resources_export.dart';

import 'package:lamis/widgets/widgets.dart';

import '../screens.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationsCubit notificationsCubit;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    notificationsCubit = NotificationsCubit()..getNotifications(pageNumber: 1);

    _scrollController.addListener(() {
      if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        notificationsCubit.getNotifications(pageNumber: ++pageNumber);
      }
    });
    super.initState();
  }

  int pageNumber = 1;

  Set<NotificationData> notifications = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
      appBar: CustomAppBar(
        title: context.resources.strings.notification,
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        bloc: notificationsCubit,
        builder: (context, state) {
          if (state is NotificationsDone) {
            notifications.addAll(state.notificationResponse?.data ?? {});
            {
              if (notifications.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const FixedHieght(
                      extra: true,
                    ),
                    SizedBox(
                      height: context.resources.dimension.largeContainerSize,
                      width: context.resources.dimension.largeContainerSize,
                      child: Image(
                        image: AssetImage(
                          context.resources.images.noDataImage,
                        ),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 1.4,
                      child: ListView.builder(
                          controller: _scrollController,
                          itemCount: notifications.length,
                          itemBuilder: (BuildContext context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(context
                                        .resources.dimension.defaultMargin),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .darkBlue)),
                                height: context
                                    .resources.dimension.smallContainerSize,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: context
                                          .resources.dimension.defaultMargin),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: CustomText(
                                          content: notifications
                                                  .elementAt(index)
                                                  .title ??
                                              '',
                                          titletype: TitleType.bottoms,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryTextColor,
                                          language: context
                                                      .read<LocalizationCubit>()
                                                      .state ==
                                                  const Locale('ar', "")
                                              ? Language.rtl
                                              : Language.ltr,
                                        ),
                                      ),
                                      Expanded(
                                        child: CustomText(
                                          content: notifications
                                                  .elementAt(index)
                                                  .text ??
                                              '',
                                          titletype: TitleType.body,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .subText,
                                          language: context
                                                      .read<LocalizationCubit>()
                                                      .state ==
                                                  const Locale('ar', "")
                                              ? Language.rtl
                                              : Language.ltr,
                                        ),
                                      ),
                                      Expanded(
                                        child: CustomText(
                                          content: notifications
                                                  .elementAt(index)
                                                  .createdAt ??
                                              '',
                                          titletype: TitleType.time,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .subText,
                                          language: context
                                                      .read<LocalizationCubit>()
                                                      .state ==
                                                  const Locale('ar', "")
                                              ? Language.rtl
                                              : Language.ltr,
                                        ),
                                      )
                                    ],
                                  ).customMargins(),
                                ),
                              ),
                            );
                          }).customMargins(),
                    ),
                    const FixedHieght(),
                    if (state.loading) const LinearProgressIndicator(),
                  ],
                );
              }
            }
          }
          if (state is NotificationsError) {
            return CustomErrorWidget(onTap: () {
              notificationsCubit.getNotifications();
              _scrollController.addListener(() {
                if (_scrollController.offset ==
                    _scrollController.position.maxScrollExtent) {
                  notificationsCubit.getNotifications(pageNumber: ++pageNumber);
                }
              });
            }).customMargins();
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
                itemCount: 3,
                itemBuilder: (BuildContext context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            context.resources.dimension.defaultMargin),
                        color: Theme.of(context)
                            .colorScheme
                            .darkBlue
                            .withOpacity(0.6),
                      ),
                      height: context.resources.dimension.middleContainerSize,
                      width: MediaQuery.of(context).size.width,
                    ),
                  );
                }).customMargins(),
          );
        },
      ),
    );
  }
}
