import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../res/resources_export.dart';
import '../../screens/screens.dart';

class BrandSquareCard extends StatefulWidget {
  final int id;
  final String image;
  final String name;

  const BrandSquareCard(
      {Key? key, required this.id, required this.image, required this.name})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BrandSquareCardState createState() => _BrandSquareCardState();
}

class _BrandSquareCardState extends State<BrandSquareCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.heavyImpact();
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return BrandProducts(
            id: widget.id,
            brandName: widget.name,
          );
        }));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Theme.of(context).colorScheme.border, width: 1.0),
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                  width: double.infinity,
                  height: ((MediaQuery.of(context).size.width - 24) / 2) * .72,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16), bottom: Radius.zero),
                      child: FadeInImage.assetNetwork(
                        placeholder: context.resources.images.logoImage,
                        image: widget.image,
                        fit: BoxFit.scaleDown,
                      ))),
              SizedBox(
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(
                    widget.name,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.border,
                        fontSize: 14,
                        height: 1.6,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
