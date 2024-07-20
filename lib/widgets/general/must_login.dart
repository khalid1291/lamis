import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lamis/repos/repos.dart';

import '../../res/resources_export.dart';
import '../../screens/screens.dart';
import '../widgets.dart';

class MustLogin extends StatelessWidget {
  const MustLogin({
    Key? key,
    this.function,
  }) : super(key: key);
  final VoidCallback? function;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: context.resources.dimension.priceContainer,
          ),
          SizedBox(
            height: context.resources.dimension.largeContainerSize,
            width: context.resources.dimension.largeContainerSize,
            child: Image(
              image: AssetImage(
                context.resources.images.mustLoginImage,
              ),
              fit: BoxFit.fitWidth,
            ),
          ),
          const FixedHieght(
            extra: true,
          ),
          Center(
            child: CustomText(
              content: context.resources.strings.mustLogIn,
              color: Theme.of(context).colorScheme.primaryTextColor,
              titletype: TitleType.headline,
              language: Language.center,
            ),
          ),
          const FixedHieght(
            extra: true,
          ),
          CustomButton(
              onPress: () async {
                HapticFeedback.heavyImpact();
                var result = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return LoginScreen(
                    prevCountry: UserRepo().country,
                  );
                }));
                if (result != null && result[0]) {
                  // function;
                  // ignore: use_build_context_synchronously
                  Navigator.maybePop(context);
                }
              },
              content: context.resources.strings.login),
          SizedBox(
            height: context.resources.dimension.veryHighElevation,
          ),
        ],
      ),
    );
  }
}
