import 'package:flutter/material.dart';
import '../../res/resources_export.dart';

// Do NOT use ListView or any scrollable Widget with Small type
// if you need a scrollable view, use Big type!
// Small type is limited by screen height, so be sure to follow
// that constrain.

class BottomSheets {
  static Future<dynamic> showModal(
    BuildContext context, {
    BottomSheetType type = BottomSheetType.small,
    bool hasBorderMargin = false,
    bool hasOpacity = false,
    required Widget child,
  }) async {
    return showModalBottomSheet<dynamic>(
      backgroundColor: Colors.transparent,
      context: context,
      barrierColor: hasOpacity
          ? Theme.of(context).colorScheme.shadowColor.withOpacity(0.4)
          : Theme.of(context).colorScheme.shadowColor.withOpacity(0.4),
      isScrollControlled: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return Popover(
          hasBorderMargin: hasBorderMargin,
          type: type,
          child: child,
        );
      },
    );
  }
}

enum BottomSheetType { small, big }

class Popover extends StatelessWidget {
  final bool hasBorderMargin;
  final BottomSheetType type;

  const Popover({
    Key? key,
    required this.child,
    this.hasBorderMargin = false,
    this.type = BottomSheetType.small,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(hasBorderMargin ? 30 : 0),
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height / 3,
        maxHeight: MediaQuery.of(context).size.height * 8 / 10,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.scaffoldColor,
              Theme.of(context).colorScheme.scaffoldColor,
              Theme.of(context).colorScheme.scaffoldColor,
              Theme.of(context).colorScheme.lightBlue,
            ]
            // Theme.of(context).colorScheme.blueShadeLiner

            ),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(
            40,
          ),
          bottomRight: Radius.circular(
            hasBorderMargin ? 40 : 0,
          ),
          topRight: const Radius.circular(
            40,
          ),
          bottomLeft: Radius.circular(
            hasBorderMargin ? 40 : 0,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(context),
          if (type == BottomSheetType.small) child else Expanded(child: child),
          if (MediaQuery.of(context).viewInsets.bottom == 0)
            SizedBox(height: context.resources.dimension.extraHighElevation),
          if (type == BottomSheetType.small)
            Padding(padding: MediaQuery.of(context).viewInsets)
        ],
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    // final ThemeData theme = Theme.of(context);

    return FractionallySizedBox(
      widthFactor: 0.1,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 30.0,
        ),
        child: Container(
          height: 5.0,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.shadowColor,
            borderRadius: const BorderRadius.all(Radius.circular(2.5)),
          ),
        ),
      ),
    );
  }
}
