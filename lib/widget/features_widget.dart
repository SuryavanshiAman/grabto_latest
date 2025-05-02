import 'package:grabto/model/features_model.dart';
import 'package:grabto/widget/feature_tile_widget.dart';
import 'package:flutter/material.dart';

class FeaturesWidget extends StatefulWidget {
  List<FeaturesModel> featuresList = [];

  FeaturesWidget(this.featuresList);

  @override
  _FeaturesWidgetState createState() => _FeaturesWidgetState();
}

class _FeaturesWidgetState extends State<FeaturesWidget> {
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    return widget.featuresList.length!=0? Container(
      height: 50,
      // color: Colors.blue,
      child: ListView.builder(
        shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        // padding: EdgeInsets.all(8),
        scrollDirection: Axis.horizontal,
        itemCount:widget.featuresList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8),
            child: FeatureTile(
              title: widget.featuresList[index].name,
              image: widget.featuresList[index].image,
            ),
          );
        },
      ),
    ):Container();

    // GridView.count(
    //   crossAxisCount: 2,
    //   shrinkWrap: true,
    //   // To limit the size to children's size
    //   childAspectRatio: 4,
    //   //// Adjust aspect ratio as needed
    //   physics: NeverScrollableScrollPhysics(),
    //   children: [
    //     for (var feature in widget.featuresList)
    //       FeatureTile(
    //         title: feature.name,
    //         image: feature.image,
    //       ),
    //   ],
    // );
  }
}