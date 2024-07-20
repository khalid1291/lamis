import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/res/resources_export.dart';

import '../../blocs/blocs.dart';
import '../../cubits/cubits.dart';
import '../../widgets/widgets.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetConnectionCubit, bool>(
      bloc: context.read<InternetConnectionCubit>(),
      listener: (context, state) {
        if (state) {
          context.read<AppBloc>().add(FetchAppData());
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        body: Padding(
          padding: EdgeInsets.all(context.resources.dimension.bigMargin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: context.resources.dimension.bigMargin,
              ),
              SizedBox(
                height: context.resources.dimension.largeContainerSize,
                width: context.resources.dimension.largeContainerSize,
                child: Image(
                  image: AssetImage(context.resources.images.offlineImage),
                  fit: BoxFit.fitWidth,
                ),
              ),
              Center(
                child: CustomText(
                  content: context.resources.strings.offline,
                  color: Theme.of(context).colorScheme.primaryTextColor,
                  titletype: TitleType.headline,
                  language: Language.center,
                ),
              ),
              SizedBox(
                height: context.resources.dimension.lightElevation,
              )
            ],
          ),
        ),
      ),
    );
  }
}
