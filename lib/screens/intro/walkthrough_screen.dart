import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/cubits/cubits.dart';

import '../../blocs/blocs.dart';
import '../../res/resources_export.dart';
import '../../widgets/widgets.dart';

class WalkThroughScreen extends StatefulWidget {
  const WalkThroughScreen({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _WalkThroughScreenState createState() => _WalkThroughScreenState();
}

class _WalkThroughScreenState extends State<WalkThroughScreen> {
  int currentPageValue = 0;
  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    final List<Widget> introWidgetsList = <Widget>[
      _OneScreen(
        image: context.resources.images.secondWalk,
        tile: context.resources.strings.welcomeToLamisEStore,
        subTitle: context.resources.strings.findTheBestProducts,
      ),
      _OneScreen(
        image: context.resources.images.firstWalk,
        tile: context.resources.strings.addItemsToCart,
        subTitle: context.resources.strings.placeYourOrderAndProceed,
      ),
      _OneScreen(
        image: context.resources.images.thirdWalk,
        tile: context.resources.strings.confirmAndCheckout,
        subTitle: context.resources.strings.finalizeYourOrder,
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Theme.of(context).colorScheme.scaffoldColor,
                      Theme.of(context).colorScheme.scaffoldColor,
                      Theme.of(context).colorScheme.scaffoldColor,
                      Theme.of(context).colorScheme.drawerLayerTow,
                    ],
                  ))),
              Positioned(
                top: -150,
                child: Container(
                    height: MediaQuery.of(context).size.height / 1.6,
                    width: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: <Color>[
                          Theme.of(context).colorScheme.lightBlue,
                          Theme.of(context).colorScheme.drawerLayerOne,
                          Theme.of(context).colorScheme.lightBlue,
                          // Theme.of(context).colorScheme.drawerLayerOne,
                          Theme.of(context).colorScheme.scaffoldColor,
                        ],
                      ),
                    )),
              ),
              Positioned(
                top: -150,
                child: Container(
                    height: MediaQuery.of(context).size.height / 1.6 - 20,
                    width: MediaQuery.of(context).size.height - 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          Theme.of(context).colorScheme.scaffoldColor,
                          Theme.of(context).colorScheme.drawerLayerOne,
                          Theme.of(context).colorScheme.darkBlue,
                          Theme.of(context).colorScheme.scaffoldColor
                        ],
                      ),
                    )),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: PageView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: introWidgetsList.length,
                    onPageChanged: (int page) {
                      getChangedPageAndMoveBar(page);
                    },
                    controller: controller,
                    itemBuilder: (context, index) {
                      return SizedBox(child: introWidgetsList[index]);
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(
                      bottom: context.resources.dimension.extraHighElevation),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i < introWidgetsList.length; i++)
                        if (i == currentPageValue) ...[
                          circleBar(true, context)
                        ] else
                          circleBar(false, context),
                    ],
                  ),
                ),
              ),
              if (currentPageValue == introWidgetsList.length - 1)
                Align(
                  alignment: context.read<LocalizationCubit>().state ==
                          const Locale('ar', '')
                      ? Alignment.bottomLeft
                      : Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.all(
                        context.resources.dimension.extraHighElevation),
                    child: NeumorphismContainer(
                      child: FloatingActionButton(
                        elevation: 0.0,
                        onPressed: () {
                          context.read<AppBloc>().add(ContinueAsGuest());
                          Navigator.maybePop(context);
                        },
                        backgroundColor:
                            Theme.of(context).colorScheme.scaffoldColor,
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Theme.of(context).colorScheme.lamisColor,
                        ),
                      ),
                    ),
                  ),
                )
            ],
          )),
    );
  }
}

class _OneScreen extends StatelessWidget {
  const _OneScreen({
    Key? key,
    required this.image,
    required this.tile,
    required this.subTitle,
  }) : super(key: key);

  final String image;
  final String tile;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 5,
        ),
        SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width / 1.3,
            child: Image(
                image: AssetImage(
                  image,
                ),
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height / 3)),
        Expanded(
          child: CustomText(
            content: tile,
            language: Language.center,
            titletype: TitleType.headline,
            color: Theme.of(context).colorScheme.primaryTextColor,
          ).customMargins(),
        ),
        Expanded(
          child: CustomText(
            content: subTitle,
            language: Language.center,
            titletype: TitleType.subtitle,
            color: Theme.of(context).colorScheme.subText,
          ).customMargins(),
        ),
      ],
    );
  }
}

Widget circleBar(bool isActive, BuildContext context) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 150),
    margin: const EdgeInsets.symmetric(horizontal: 8),
    height: isActive ? 12 : 8,
    width: isActive ? 12 : 8,
    decoration: BoxDecoration(
        color:
            isActive ? Theme.of(context).colorScheme.lamisColor : Colors.grey,
        borderRadius: const BorderRadius.all(Radius.circular(12))),
  );
}
